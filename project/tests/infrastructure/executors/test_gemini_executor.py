import unittest
from unittest.mock import MagicMock, patch
from github_broker.infrastructure.executors.gemini_executor import GeminiExecutor


class TestGeminiExecutor(unittest.TestCase):

    def setUp(self):
        # 準備
        self.mock_gemini_model = MagicMock()
        self.executor = GeminiExecutor(gemini_model=self.mock_gemini_model)

    def test_execute_successful_tool_call(self):
        # 準備
        mock_response = MagicMock()
        mock_function_call = MagicMock()
        mock_function_call.name = "run_shell_command"
        mock_function_call.args = {"command": "ls -l"}
        mock_response.candidates[0].content.parts = [
            MagicMock(function_call=mock_function_call)]
        self.mock_gemini_model.generate_content.return_value = mock_response

        mock_tool_response = MagicMock()
        mock_tool_response.function_response.name = "run_shell_command"
        mock_tool_response.function_response.response = {
            "stdout": "total 0\n-rw-r--r-- 1 user group 0 Aug 19 10:00 README.md\n",
            "stderr": "",
            "exit_code": 0
        }
        self.mock_gemini_model.tool.from_function_response.return_value = mock_tool_response

        # 実行
        result = self.executor.execute("Show me the files")

        # 検証
        self.assertIn("tool_code", result)
        self.assertIn("stdout", result["tool_code_output"])
        self.assertEqual(result["tool_code_output"]["exit_code"], 0)
        self.mock_gemini_model.generate_content.assert_called()

    def test_execute_no_tool_call_in_response(self):
        # 準備
        mock_response = MagicMock()
        mock_response.candidates[0].content.parts = []  # ツールコールなし
        self.mock_gemini_model.generate_content.return_value = mock_response

        # 実行
        result = self.executor.execute("Just chat")

        # 検証
        self.assertIsNone(result.get("tool_code"))
        self.assertIn("text", result)

    def test_execute_with_error_in_tool_execution(self):
        # 準備
        mock_response = MagicMock()
        mock_function_call = MagicMock()
        mock_function_call.name = "run_shell_command"
        mock_function_call.args = {"command": "invalid_command"}
        mock_response.candidates[0].content.parts = [
            MagicMock(function_call=mock_function_call)]
        self.mock_gemini_model.generate_content.return_value = mock_response

        mock_tool_response = MagicMock()
        mock_tool_response.function_response.name = "run_shell_command"
        mock_tool_response.function_response.response = {
            "stdout": "",
            "stderr": "bash: invalid_command: command not found",
            "exit_code": 127
        }
        self.mock_gemini_model.tool.from_function_response.return_value = mock_tool_response

        # 実行
        result = self.executor.execute("Run an invalid command")

        # 検証
        self.assertIn("tool_code", result)
        self.assertEqual(result["tool_code_output"]["exit_code"], 127)
        self.assertIn("command not found",
                      result["tool_code_output"]["stderr"])


if __name__ == '__main__':
    unittest.main()
