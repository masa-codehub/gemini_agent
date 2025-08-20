import unittest
from unittest.mock import MagicMock, patch
from github_broker.infrastructure.github_client import GitHubClient

class TestGitHubClient(unittest.TestCase):

    @patch('github_broker.infrastructure.github_client.Github')
    def setUp(self, MockGithub):
        # 準備
        self.mock_github_instance = MockGithub.return_value
        self.mock_repo = MagicMock()
        self.mock_github_instance.get_repo.return_value = self.mock_repo
        self.client = GitHubClient(auth_token="fake_token")

    def test_get_issue_successfully(self):
        # 準備
        mock_issue = MagicMock()
        mock_issue.number = 123
        mock_issue.title = "Test Issue Title"
        mock_issue.body = "This is the body of the test issue."
        self.mock_repo.get_issue.return_value = mock_issue

        # 実行
        issue = self.client.get_issue("owner", "repo_name", 123)

        # 検証
        self.mock_github_instance.get_repo.assert_called_once_with("owner/repo_name")
        self.mock_repo.get_issue.assert_called_once_with(number=123)
        self.assertEqual(issue["title"], "Test Issue Title")
        self.assertEqual(issue["body"], "This is the body of the test issue.")

    def test_get_issue_not_found(self):
        # 準備
        self.mock_repo.get_issue.side_effect = Exception("Issue not found")

        # 実行 & 検証
        with self.assertRaises(Exception):
            self.client.get_issue("owner", "repo_name", 404)

    def test_create_pull_request_successfully(self):
        # 準備
        mock_pr = MagicMock()
        mock_pr.html_url = "http://example.com/pr/1"
        self.mock_repo.create_pull.return_value = mock_pr

        # 実行
        pr_url = self.client.create_pull_request(
            "owner", "repo_name", "feat/new-feature", "main", "New Feature", "PR body"
        )

        # 検証
        self.mock_repo.create_pull.assert_called_once_with(
            title="New Feature",
            body="PR body",
            head="feat/new-feature",
            base="main"
        )
        self.assertEqual(pr_url, "http://example.com/pr/1")

    def test_add_issue_comment_successfully(self):
        # 準備
        mock_issue = MagicMock()
        self.mock_repo.get_issue.return_value = mock_issue

        # 実行
        self.client.add_issue_comment("owner", "repo_name", 123, "This is a comment.")

        # 検証
        self.mock_repo.get_issue.assert_called_once_with(number=123)
        mock_issue.create_comment.assert_called_once_with("This is a comment.")


# --- Integration Tests --- #
# 統合テストは、実際の外部サービス（この場合はGitHub API）に接続して実行されます。
# 実行するには、有効なGitHubトークンと、テスト対象のリポジトリが必要です。
# これらのテストは通常、CI環境でのみ実行され、ローカルでの開発中はスキップされます。

# @unittest.skipUnless(os.environ.get('RUN_INTEGRATION_TESTS'), "Integration tests are skipped by default")
# class TestGitHubClientIntegration(unittest.TestCase):

#     def setUp(self):
#         # 準備: 環境変数から認証情報を読み込みます
#         self.token = os.environ.get('GITHUB_TOKEN')
#         self.repo_name = os.environ.get('GITHUB_TEST_REPO') # 例: "your_username/your_test_repo"
#         self.client = GitHubClient(auth_token=self.token)
#         self.assertIsNotNone(self.token, "GITHUB_TOKEN is not set")
#         self.assertIsNotNone(self.repo_name, "GITHUB_TEST_REPO is not set")

#     def test_get_real_issue(self):
#         # 準備: テスト用のIssueを事前に作成しておく必要があります
#         # このテストでは、リポジトリに存在するIssue #1を取得しようとします
#         owner, repo = self.repo_name.split('/')
        
#         # 実行
#         try:
#             issue = self.client.get_issue(owner, repo, 1)
#             # 検証
#             self.assertIsNotNone(issue)
#             self.assertEqual(issue['number'], 1)
#         except Exception as e:
#             self.fail(f"Failed to get a real issue: {e}")

if __name__ == '__main__':
    unittest.main()
