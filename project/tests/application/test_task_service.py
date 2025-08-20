import unittest
from unittest.mock import MagicMock, patch

from github_broker.application.task_service import TaskService
from github_broker.application.exceptions import TaskProcessingError


class TestTaskService(unittest.TestCase)

   def setUp(self):
        self.mock_github_client = MagicMock()
        self.mock_gemini_client = MagicMock()
        self.mock_redis_client = MagicMock()
        self.task_service = TaskService(
            github_client=self.mock_github_client,
            gemini_client=self.mock_gemini_client,
            redis_client=self.mock_redis_client
        )

    def test_execute_task_success(self):
        # Arrange
        self.mock_redis_client.acquire_lock.return_value = True
        self.mock_github_client.get_issue.return_value = {
            "title": "Test Issue",
            "body": "This is a test issue."
        }
        self.mock_gemini_client.chat.return_value = "This is a test solution."

        # Act
        result = self.task_service.execute_task("test_owner", "test_repo", 123)

        # Assert
        self.assertEqual(result, "This is a test solution.")
        self.mock_redis_client.acquire_lock.assert_called_once_with(
            "task_lock:test_owner:test_repo:123", 300)
        self.mock_github_client.get_issue.assert_called_once_with(
            "test_owner", "test_repo", 123)
        self.mock_gemini_client.chat.assert_called_once()
        self.mock_redis_client.release_lock.assert_called_once_with(
            "task_lock:test_owner:test_repo:123")

    def test_execute_task_lock_failed(self):
        # Arrange
        self.mock_redis_client.acquire_lock.return_value = False

        # Act
        result = self.task_service.execute_task("test_owner", "test_repo", 123)

        # Assert
        self.assertIsNone(result)
        self.mock_redis_client.acquire_lock.assert_called_once_with(
            "task_lock:test_owner:test_repo:123", 300)
        self.mock_github_client.get_issue.assert_not_called()

    def test_execute_task_get_issue_failed(self):
        # Arrange
        self.mock_redis_client.acquire_lock.return_value = True
        self.mock_github_client.get_issue.side_effect = Exception(
            "GitHub Error")

        # Act & Assert
        with self.assertRaises(TaskProcessingError) as cm:
            self.task_service.execute_task("test_owner", "test_repo", 123)

        self.assertEqual(str(cm.exception),
                         "Failed to get issue: GitHub Error")
        self.mock_redis_client.release_lock.assert_called_once_with(
            "task_lock:test_owner:test_repo:123")

    def test_execute_task_chat_failed(self):
        # Arrange
        self.mock_redis_client.acquire_lock.return_value = True
        self.mock_github_client.get_issue.return_value = {
            "title": "Test", "body": "Body"}
        self.mock_gemini_client.chat.side_effect = Exception("Gemini Error")

        # Act & Assert
        with self.assertRaises(TaskProcessingError) as cm:
            self.task_service.execute_task("test_owner", "test_repo", 123)

        self.assertEqual(str(cm.exception),
                         "Failed to execute chat: Gemini Error")
        self.mock_redis_client.release_lock.assert_called_once_with(
            "task_lock:test_owner:test_repo:123")

    def test_execute_task_release_lock_failed(self):
        # Arrange
        self.mock_redis_client.acquire_lock.return_value = True
        self.mock_github_client.get_issue.return_value = {
            "title": "Test", "body": "Body"}
        self.mock_gemini_client.chat.return_value = "Solution"
        self.mock_redis_client.release_lock.side_effect = Exception(
            "Redis Error")
        self.mock_redis_client.delete_key = MagicMock()

        # Act
        result = self.task_service.execute_task("test_owner", "test_repo", 123)

        # Assert
        self.assertEqual(result, "Solution")
        self.mock_redis_client.delete_key.assert_called_once_with("task_lock:test_owner:test_repo:123")  # それでも呼び出される


if __name__ == '__main__':
    unittest.main()
