import unittest
from unittest.mock import MagicMock, patch
from github_broker.infrastructure.gemini_client import GeminiClient

class TestGeminiClient(unittest.TestCase):

    @patch('github_broker.infrastructure.gemini_client.genai.GenerativeModel')
    def setUp(self, MockGenerativeModel):
        # 準備
        self.mock_model_instance = MockGenerativeModel.return_value
        self.client = GeminiClient(api_key="test_api_key")

    def test_chat_successful(self):
        # 準備
        mock_response = MagicMock()
        mock_response.text = "Hello, this is a response."
        self.mock_model_instance.generate_content.return_value = mock_response

        # 実行
        response = self.client.chat("Hello, world!")

        # 検証
        self.assertEqual(response, "Hello, this is a response.")
        self.mock_model_instance.generate_content.assert_called_once_with(
            "Hello, world!",
            generation_config=self.client.generation_config,
            safety_settings=self.client.safety_settings
        )

    def test_chat_with_exception(self):
        # 準備
        self.mock_model_instance.generate_content.side_effect = Exception("API Error")

        # 実行 & 検証
        with self.assertRaises(Exception) as context:
            self.client.chat("This will fail")
        
        self.assertTrue('API Error' in str(context.exception))

if __name__ == '__main__':
    unittest.main()
