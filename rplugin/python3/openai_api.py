import os

import openai
import pynvim
from pynvim import Nvim

MODEL_CHAT = "gpt-3.5-turbo"
MODEL_COMPLETION = "text-davinci-003"

TEMPERATURE = 1
TOP_P = 1
MAX_TOKENS = 2048


def get_api_key():
    return os.environ.get("OPENAI_API_KEY")


def get_prompt(nvim: Nvim, args):
    prompt = ""
    start_row, start_col = nvim.funcs.getpos("'<")[1:3]
    end_row, end_col = nvim.funcs.getpos("'>")[1:3]
    if start_row != end_row or start_col != end_col:
        prompt = nvim.funcs.getline(start_row, end_row)
        prompt = "\n".join(map(str, prompt))
        nvim.funcs.setpos("'<", (0, 0, 0, 0))
        nvim.funcs.setpos("'>", (0, 0, 0, 0))
    else:
        if len(args) > 0:
            prompt = " ".join(args)
    return prompt


@pynvim.function("OpenAIGPTChat", sync=True)
def chat(nvim: Nvim, args) -> str:
    api_key = get_api_key()
    if api_key is not None:
        openai.api_key = api_key
        prompt = get_prompt(nvim, args)
        response = openai.ChatCompletion.create(
            model=MODEL_CHAT,
            temperature=TEMPERATURE,
            top_p=TOP_P,
            messages=[{"role": "user", "content": prompt}],
        )
        return response["choices"][0]["message"]["content"].strip()
    else:
        nvim.err_write("OPENAI_API_KEY is not set\n")
    return ""


@pynvim.function("OpenAIGPTCompletion", sync=True)
def completion(nvim: Nvim, args) -> str:
    api_key = get_api_key()
    if api_key is not None:
        openai.api_key = api_key
        prompt = get_prompt(nvim, args)
        response = openai.Completion.create(
            model=MODEL_COMPLETION,
            prompt=prompt,
            temperature=TEMPERATURE,
            top_p=TOP_P,
            max_tokens=MAX_TOKENS,
        )
        return response["choices"][0]["text"].strip()
    else:
        nvim.err_write("OPENAI_API_KEY is not set\n")
    return ""
