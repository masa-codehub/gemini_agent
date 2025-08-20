from unittest.mock import MagicMock, patch

import pytest

from github_broker.infrastructure.gemini_client import GeminiClient


@patch("os.getenv")
def test_gemini_client_init_success(mock_getenv):
    """
    Test that GeminiClient initializes successfully when GEMINI_API_KEY is set.
    """
    mock_getenv.return_value = "fake_gemini_api_key"
    client = GeminiClient()
    assert client._api_key == "fake_gemini_api_key"
    mock_getenv.assert_called_once_with("GEMINI_API_KEY")


@patch("os.getenv")
def test_gemini_client_init_no_api_key(mock_getenv):
    """
    Test that GeminiClient raises ValueError if GEMINI_API_KEY is not set.
    """
    mock_getenv.return_value = None
    with pytest.raises(
        ValueError,
        match="Gemini API key not found in GEMINI_API_KEY environment variable.",
    ):
        GeminiClient()
    mock_getenv.assert_called_once_with("GEMINI_API_KEY")


@patch("os.getenv")
def test_select_best_issue_id_no_issues(mock_getenv):
    """
    Test select_best_issue_id when no issues are provided.
    """
    mock_getenv.return_value = "fake_gemini_api_key"
    client = GeminiClient()

    issues = []
    capabilities = ["python"]

    selected_id = client.select_best_issue_id(issues, capabilities)

    assert selected_id is None


@patch("os.getenv")
@patch("github_broker.infrastructure.gemini_client.genai.GenerativeModel")
def test_select_best_issue_id_with_gemini_api_call(mock_generative_model, mock_getenv):
    """
    Test that select_best_issue_id correctly calls the Gemini API,
    generates a prompt, and parses the response.
    """
    # 準備
    mock_getenv.return_value = "fake_gemini_api_key"

    # Gemini APIからのレスポンスをモック化
    mock_gemini_response = MagicMock()
    # レスポンスのテキストはJSON文字列である必要があります。
    mock_gemini_response.text = '''{"issue_id": 101}'''

    # モデルのgenerate_contentメソッドはモックのレスポンスを返します
    mock_model_instance = MagicMock()
    mock_model_instance.generate_content.return_value = mock_gemini_response
    mock_generative_model.return_value = mock_model_instance

    client = GeminiClient()

    issues = [
        {
            "id": 101,
            "title": "Refactor database module",
            "body": "The DB module is too complex.",
            "labels": ["refactoring", "python"],
        },
        {
            "id": 102,
            "title": "Fix login bug",
            "body": "User cannot log in.",
            "labels": ["bug", "frontend"],
        },
    ]
    capabilities = ["python", "refactoring", "backend"]

    # 実行
    selected_id = client.select_best_issue_id(issues, capabilities)

    # 検証
    # モデルが呼び出されたことを確認
    mock_model_instance.generate_content.assert_called_once()

    # モデルに送信された実際のプロンプトを取得
    actual_prompt = mock_model_instance.generate_content.call_args[0][0]

    # プロンプトにキー情報が含まれていることを確認
    assert "Refactor database module" in actual_prompt
    assert "python" in actual_prompt
    assert "refactoring" in actual_prompt
    assert "backend" in actual_prompt
    # dedentされたプロンプトからキーフレーズを確認
    assert "You are an expert software development project manager." in actual_prompt
    assert '''{"issue_id": <id>}''' in actual_prompt

    # 結果が正しく解析されたことを確認
    assert selected_id == 101


@patch("os.getenv")
@patch("github_broker.infrastructure.gemini_client.genai.GenerativeModel")
def test_select_best_issue_id_fallback_on_api_error(mock_generative_model, mock_getenv):
    """
    Test that select_best_issue_id falls back to the first issue if the API call fails.
    """
    # 準備
    mock_getenv.return_value = "fake_gemini_api_key"

    # API呼び出しをモックして例外を発生させる
    mock_model_instance = MagicMock()
    mock_model_instance.generate_content.side_effect = Exception("API Key Invalid")
    mock_generative_model.return_value = mock_model_instance

    client = GeminiClient()

    issues = [
        {"id": 201, "title": "First Issue"},
        {"id": 202, "title": "Second Issue"},
    ]
    capabilities = ["*"]

    # 実行
    selected_id = client.select_best_issue_id(issues, capabilities)

    # 検証
    # フォールバックメカニズムが最初のIssueのIDを返したことを確認
    assert selected_id == 201