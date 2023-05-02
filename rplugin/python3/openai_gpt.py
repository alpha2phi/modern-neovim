import os

import pynvim
from pynvim import Nvim


MODEL = "gpt-3.5-turbo"

API_KEY = os.environ.get("OPENAI_API_KEY")
if API_KEY is None:
    print("OPENAI_API_KEY is not set")


@pynvim.plugin
class OpenAIGPT(object):
    def __init__(self, nvim: Nvim):
        self.nvim = nvim

    @pynvim.command("OpenAIGPTChat", nargs="*", range="", sync=False)
    def chat(self, args, range):
        if len(args) > 0:
            text = args[0]
        else:
            text = self.nvim.funcs.getline(range[0], range[1])
            text = "\n".join(map(str, text))

    @pynvim.command("OpenAIGPTCompletion", nargs="*", range="", sync=False)
    def completion(self, args, range):
        if len(args) > 0:
            text = args[0]
        else:
            text = self.nvim.funcs.getline(range[0], range[1])
            text = "\n".join(map(str, text))
