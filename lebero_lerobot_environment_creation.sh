#!/usr/bin/env bash
set -euo pipefail

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  cat <<'HELP'
Usage:
  bash lebero_lerobot_environment_creation.sh [WORKSPACE_DIR]

Description:
  Clone compatible LeRobot + LIBERO repos, create venv, install dependencies,
  and run a simulation smoke test for benchmark suites:
  libero_10 / libero_goal / libero_object / libero_spatial.

Note:
  `bash -n lebero_lerobot_environment_creation.sh` only checks syntax and
  normally prints no output when there is no syntax error.
HELP
  exit 0
fi

# Compatible pair:
# - LeRobot v0.5.0
# - huggingface/lerobot-libero main
LEROBOT_REPO="https://github.com/huggingface/lerobot.git"
LEROBOT_REF="v0.5.0"
LIBERO_REPO="https://github.com/huggingface/lerobot-libero.git"
LIBERO_REF="main"

ROOT_DIR="${1:-$PWD/workspace_libero_lerobot}"
PYTHON_BIN="${PYTHON_BIN:-python3}"

echo "[1/6] Preparing workspace: $ROOT_DIR"
mkdir -p "$ROOT_DIR"
cd "$ROOT_DIR"

echo "[2/6] Cloning LeRobot ($LEROBOT_REF)"
if [ ! -d lerobot/.git ]; then
  git clone "$LEROBOT_REPO" lerobot
fi
cd lerobot
git fetch --tags
git checkout "$LEROBOT_REF" 2>/dev/null || git checkout "tags/$LEROBOT_REF"
cd ..

echo "[3/6] Cloning LIBERO fork ($LIBERO_REF)"
if [ ! -d libero/.git ]; then
  git clone "$LIBERO_REPO" libero
fi
cd libero
git fetch origin
git checkout "$LIBERO_REF" 2>/dev/null || git checkout "origin/$LIBERO_REF"
cd ..

echo "[4/6] Creating virtual environment"
$PYTHON_BIN -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip setuptools wheel

echo "[5/6] Installing packages"
pip install -e ./lerobot
pip install -e ./libero

echo "[6/6] Smoke test in simulation (headless, no training)"
python - <<'PY'
from libero.libero import benchmark

benchmark_dict = benchmark.get_benchmark_dict()
for name in ["libero_10", "libero_goal", "libero_object", "libero_spatial"]:
    assert name in benchmark_dict, f"Missing benchmark: {name}"
print("[OK] Found benchmark suites:", ["libero_10", "libero_goal", "libero_object", "libero_spatial"])
PY

echo "Done. Next step (example SmolVLA finetune):"
echo "  source $ROOT_DIR/.venv/bin/activate"
echo "  cd $ROOT_DIR/lerobot"
echo "  python -m lerobot.scripts.train --help"
