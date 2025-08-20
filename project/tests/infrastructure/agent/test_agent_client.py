import unittest
from unittest.mock import MagicMock, patch
from github_broker.infrastructure.agent.client import AgentClient

class TestAgentClient(unittest.TestCase):

    def setUp(self):
        # 準備
        self.mock_gemini_executor = MagicMock()
        self.agent_client = AgentClient(gemini_executor=self.mock_gemini_executor)

    def test_execute_agent_successfully(self):
        # 準備
        self.mock_gemini_executor.execute.return_value = {
            "tool_code": "print('Hello, World!')",
            "stdout": "Hello, World!\n",
            "stderr": "",
            "exit_code": 0
        }

        # 実行
        result = self.agent_client.execute_agent("test_repo", "test_issue")

        # 検証
        self.assertIn("tool_code", result)
        self.assertEqual(result["stdout"], "Hello, World!\n")
        self.mock_gemini_executor.execute.assert_called_once()
        
        # プロンプトが正しく構築されているかを検証
        called_prompt = self.mock_gemini_executor.execute.call_args[0][0]
        self.assertIn("GitHub Repository: test_repo", called_prompt)
        self.assertIn("Issue: test_issue", called_prompt)

    def test_execute_agent_with_execution_error(self):
        # 準備
        self.mock_gemini_executor.execute.return_value = {
            "tool_code": "print('Error')",
            "stdout": "",
            "stderr": "Some error occurred",
            "exit_code": 1
        }

        # 実行
        result = self.agent_client.execute_agent("error_repo", "error_issue")

        # 検証
        self.assertIn("stderr", result)
        self.assertEqual(result["exit_code"], 1)
        self.mock_gemini_executor.execute.assert_called_once()

    def test_execute_agent_with_exception(self):
        # 準備
        self.mock_gemini_executor.execute.side_effect = Exception("Executor failed")

        # 実行 & 検証
        with self.assertRaises(Exception) as context:
            self.agent_client.execute_agent("exception_repo", "exception_issue")
        
        self.assertTrue("Executor failed" in str(context.exception))

if __name__ == '__main__':
    unittest.main()
