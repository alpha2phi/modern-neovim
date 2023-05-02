import logging
import os
import unittest

import openai

response = openai.Completion.create(
    model="text-davinci-003", prompt="Say this is a test", temperature=0, max_tokens=7
)


class TestOpenAIGPT(unittest.TestCase):
    api_key: str

    def setUp(self) -> None:
        self.api_key = os.getenv("OPENAI_API_KEY")

    def test_api_key(self):
        print("API key ", self.api_key)
