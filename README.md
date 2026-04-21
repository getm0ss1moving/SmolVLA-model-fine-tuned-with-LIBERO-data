# SmolVLA + LIBERO（lebero）微调准备说明

你提到的 `lebero` 在生态里通常是 `LIBERO`（数据集名也通常写作 `libero_10/libero_goal/libero_object/libero_spatial`）。

本仓库提供脚本：

- `lebero_lerobot_environment_creation.sh`（主脚本）
- `setup_libero_lerobot.sh`（兼容旧名称的转发脚本）

## 你提到的现象说明

你执行：

```bash
bash -n lebero_lerobot_environment_creation.sh
```

没有输出是**正常现象**。`bash -n` 只做语法检查，语法正确时通常不会打印任何内容。

如果你想真正执行环境创建，请运行：

```bash
bash lebero_lerobot_environment_creation.sh
```

如果你想看脚本说明：

```bash
bash lebero_lerobot_environment_creation.sh --help
```

## 脚本会做什么

1. 从 GitHub clone `huggingface/lerobot` 并切到 `v0.5.0`
2. 从 GitHub clone `huggingface/lerobot-libero`（HF 维护、面向 LeRobot 兼容）
3. 创建 Python 虚拟环境
4. 安装两个仓库
5. 在模拟环境执行 smoke test，验证以下任务套件可被加载：
   - `libero_10`
   - `libero_goal`
   - `libero_object`
   - `libero_spatial`

## 指定工作目录

```bash
bash lebero_lerobot_environment_creation.sh /path/to/workspace_libero_lerobot
```

## 兼容版本选择

- LeRobot: `v0.5.0`
- LIBERO: `huggingface/lerobot-libero` 的 `main`

## 后续开始 SmolVLA 微调

```bash
source /path/to/workspace_libero_lerobot/.venv/bin/activate
cd /path/to/workspace_libero_lerobot/lerobot
python -m lerobot.scripts.train --help
```
