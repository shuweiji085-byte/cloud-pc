#!/usr/bin/env bash
# 云电脑开机初始化：让这台临时 Linux 立刻可用。
# 在 GitHub Codespaces / Actions / 任意 Ubuntu 里都能跑。
set -u

say() { printf '\n\033[1;36m==> %s\033[0m\n' "$*"; }

say "基础信息"
uname -a || true
echo "CPU: $(nproc) 核   内存: $(free -h | awk '/Mem:/{print $2}')   磁盘: $(df -h / | awk 'NR==2{print $2" 可用 "$4}')"

say "配置国内镜像（境外机器可跳过）"
if [ "${USE_CN_MIRROR:-no}" = "yes" ]; then
  npm config set registry https://registry.npmmirror.com 2>/dev/null || true
  pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple 2>/dev/null || true
  echo "已切换到 npmmirror / 清华 pypi"
else
  echo "跳过（设 USE_CN_MIRROR=yes 可开启）"
fi

say "常用 CLI"
for c in git curl wget jq rg fd tree htop tmux unzip zip; do
  command -v "$c" >/dev/null 2>&1 && echo "  ✓ $c" || echo "  ✗ $c（缺，可 apt-get install）"
done

say "运行时长上限提醒"
echo "Codespaces 免费额度用满是会自动停机的；Actions 单 job 默认 6 小时封顶。"

say "完成。直接敲命令就行。"
