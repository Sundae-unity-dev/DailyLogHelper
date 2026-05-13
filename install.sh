#!/usr/bin/env bash
# 일일회고록 정리 도우미 설치 스크립트 (Mac / Linux / Git Bash)

set -e

SKILL_DIR="$HOME/.claude/DailyLogHelper"
COMMANDS_DIR="$HOME/.claude/commands"

echo ""
echo "📦 일일회고록 정리 도우미 설치 중..."
echo ""

# 1) Node.js 확인
if ! command -v node >/dev/null 2>&1; then
  echo "❌ Node.js 가 설치되어 있지 않습니다."
  echo "   https://nodejs.org 에서 LTS 버전을 설치한 뒤 다시 실행해 주세요."
  exit 1
fi
echo "✓ Node.js $(node -v)"

# 2) 디렉터리 준비
mkdir -p "$SKILL_DIR"
mkdir -p "$COMMANDS_DIR"

# 3) 스킬 자산 복사
cp -f rules.md      "$SKILL_DIR/rules.md"
cp -f template.html "$SKILL_DIR/template.html"
cp -f render.js     "$SKILL_DIR/render.js"
cp -f package.json  "$SKILL_DIR/package.json"

# 4) 슬래시 커맨드 등록
cp -f "일일회고.md" "$COMMANDS_DIR/일일회고.md"

# 5) puppeteer 설치
echo ""
echo "📥 의존성 설치 중 (puppeteer, 첫 설치는 약 300MB Chromium 다운로드)..."
(cd "$SKILL_DIR" && npm install --silent)

echo ""
echo "✅ 설치 완료!"
echo ""
echo "사용법: Claude Code 에서 아래 명령을 입력하세요."
echo "  /일일회고            (대화형 — 추천)"
echo "  /일일회고 paste     (메모 한 번에 붙여넣기)"
echo ""
echo "생성된 PDF 는 ~/Desktop/일일회고/ 폴더에 저장됩니다."
echo ""
echo "💡 설치 후 Claude Code 를 새로 열어야 /일일회고 명령이 인식됩니다."
