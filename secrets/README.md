# secrets/

存放**仅运行期**使用的私密信息（校园网口令、用户口令、模型 API Key、git 邮箱等）。

- 真实文件**不要提交**：`.gitignore` 已忽略本目录下除 `README.md` 外的内容。
- 传递方式建议环境变量（见 docs/01-conventions.md），或经本地 HTTP 传入 guest，避免进入日志。
