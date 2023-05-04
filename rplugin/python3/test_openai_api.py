import logging
import os
import unittest

import openai

MODEL_CHAT = "gpt-3.5-turbo"
MODEL_COMPLETION = "text-davinci-003"

TEMPERATURE = 1
TOP_P = 1
MAX_TOKENS = 2048


class TestOpenAIGPT(unittest.TestCase):
    api_key: str

    def setUp(self) -> None:
        self.api_key = os.getenv("OPENAI_API_KEY")
        openai.api_key = self.api_key

    def test_api_key(self):
        self.assertIsNotNone(self.api_key, "API key is not configured")

    def test_completion(self):
        response = openai.Completion.create(
            model=MODEL_COMPLETION,
            prompt="Write a Python hello world program",
            temperature=TEMPERATURE,
            top_p=TOP_P,
            max_tokens=MAX_TOKENS,
        )
        print(response)
        text = response["choices"][0]["text"].strip()
        print(text)
        self.assertIsNotNone(response, "Chat response is empty")

    def test_chat(self):
        response = openai.ChatCompletion.create(
            model=MODEL_CHAT,
            temperature=TEMPERATURE,
            top_p=TOP_P,
            messages=[
                {"role": "user", "content": "Write a Python hello world program"}
            ],
        )
        content = response["choices"][0]["message"]["content"].strip()
        self.assertIsNotNone(content, "Chat response is empty")
