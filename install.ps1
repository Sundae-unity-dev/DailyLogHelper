# 일일회고록 정리 도우미 설치 스크립트 (Windows PowerShell)

$ErrorActionPreference = "Stop"

$SkillDir = "$env:USERPROFILE\.claude\DailyLogHelper"
$CommandsDir = "$env:USERPROFILE\.claude\commands"

Write-Host ""
Write-Host "📦 일일회고록 정리 도우미 설치 중..."
Write-Host ""

# 1) Node.js 확인
$node = Get-Command node -ErrorAction SilentlyContinue
if (-not $node) {
  Write-Host "❌ Node.js 가 설치되어 있지 않습니다." -ForegroundColor Red
  Write-Host "   https://nodejs.org 에서 LTS 버전을 설치한 뒤 다시 실행해 주세요."
  exit 1
}
Write-Host ("✓ Node.js " + (node -v))

# 2) 디렉터리 준비
New-Item -ItemType Directory -Force -Path $SkillDir | Out-Null
New-Item -ItemType Directory -Force -Path $CommandsDir | Out-Null

# 3) 스킬 자산 복사
Copy-Item "rules.md"      "$SkillDir\rules.md"      -Force
Copy-Item "template.html" "$SkillDir\template.html" -Force
Copy-Item "render.js"     "$SkillDir\render.js"     -Force
Copy-Item "package.json"  "$SkillDir\package.json"  -Force

# 4) 슬래시 커맨드 등록
Copy-Item "일일회고.md"   "$CommandsDir\일일회고.md" -Force

# 5) puppeteer 설치
Write-Host ""
Write-Host "📥 의존성 설치 중 (puppeteer, 첫 설치는 약 300MB Chromium 다운로드)..."
Push-Location $SkillDir
try {
  npm install --silent
} finally {
  Pop-Location
}

Write-Host ""
Write-Host "✅ 설치 완료!" -ForegroundColor Green
Write-Host ""
Write-Host "사용법: Claude Code 에서 아래 명령을 입력하세요."
Write-Host "  /일일회고            (대화형 — 추천)"
Write-Host "  /일일회고 paste     (메모 한 번에 붙여넣기)"
Write-Host ""
Write-Host "생성된 PDF 는 바탕화면\일일회고\ 폴더에 저장됩니다."
Write-Host ""
Write-Host "💡 설치 후 Claude Code 를 새로 열어야 /일일회고 명령이 인식됩니다."
