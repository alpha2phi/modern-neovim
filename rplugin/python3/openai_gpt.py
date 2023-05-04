import os

import openai
import pynvim
from pynvim import Nvim

MODEL_CHAT = "gpt-3.5-turbo"
MODEL_COMPLETION = "text-davinci-003"

TEMPERATURE = 1
TOP_P = 1
MAX_TOKENS = 2048


@pynvim.plugin
class OpenAIGPT:
    def __init__(self, nvim: Nvim):
        self.nvim = nvim

    def get_api_key(self):
        api_key = os.environ.get("OPENAI_API_KEY")
        if api_key is None:
            self.nvim.err_write("OPENAI_API_KEY is not set\n")
            return None
        return api_key

    def get_prompt(self, args):
        prompt = ""
        start_row, start_col = self.nvim.funcs.getpos("'<")[1:3]
        end_row, end_col = self.nvim.funcs.getpos("'>")[1:3]

        if start_row != end_row or start_col != end_col:
            prompt = self.nvim.funcs.getline(start_row, end_row)
            prompt = "\n".join(map(str, prompt))
            self.nvim.funcs.setpos("'<", (0, 0, 0, 0))
            self.nvim.funcs.setpos("'>", (0, 0, 0, 0))
        else:
            if len(args) > 0:
                prompt = " ".join(args)
        return prompt

    # @pynvim.command("OpenAIGPTCompletion", nargs="*", range="", sync=False)
    # def completion(self, args, range):
    #     api_key = self.get_api_key()
    #     if api_key is not None:
    #         openai.api_key = api_key
    #         prompt = self.get_prompt(args, range)
    #         response = openai.Completion.create(
    #             model=MODEL_COMPLETION,
    #             prompt=prompt,
    #             temperature=TEMPERATURE,
    #             top_p=TOP_P,
    #             max_tokens=MAX_TOKENS,
    #         )
    #         self.nvim.api.echo([[response["choices"][0]["text"].strip()]], True, {})
    #         # return response["choices"][0]["text"].strip()
    #     # return ""

    @pynvim.function("OpenAIGPTChat", sync=True)
    def chat(self, args):
        return "hello"
        # api_key = self.get_api_key()
        # if api_key is not None:
        #     openai.api_key = api_key
        #     prompt = self.get_prompt(args)
        #     response = openai.ChatCompletion.create(
        #         model=MODEL_CHAT,
        #         temperature=TEMPERATURE,
        #         top_p=TOP_P,
        #         messages=[{"role": "user", "content": prompt}],
        #     )
        #     # self.nvim.api.echo(
        #     #     [[response["choices"][0]["message"]["content"].strip()]], False, {}
        #     # )
        #     self.nvim.out_write(prompt + "\n")
        #     content = response["choices"][0]["message"]["content"].strip()
        #     return {"content:": content}
        # return {}
