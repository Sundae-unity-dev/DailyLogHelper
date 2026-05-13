# 일일회고록 정리 도우미

Unity 3기 **과제 제출 템플릿**(노션 양식) 을 PDF 로 자동 생성해주는 Claude Code 스킬입니다.

학생이 메모를 던지거나 대화하듯 답하면 AI 가 과제 양식의 5개 섹션(Scrum / Project / Trouble Shooting / Github·Blog / 기술탐구) 으로 정리하고, 노션 export 와 닮은 PDF 를 바탕화면에 저장합니다.
짧은 메모를 그대로 옮기지 않고 **한 단락 이상으로 자연스럽게 살을 붙여** 작성하며, 스크린샷을 같이 던지면 메모 맥락을 보고 **어느 섹션에 들어갈지 자동 분류**해 PDF에 삽입합니다.

> 자매품: [cardgen](https://github.com/Sundae-unity-dev/CardGen) — 학습 카드 생성기

---

## 사전 조건

- [Claude Code](https://claude.ai/code) 설치
- [Node.js](https://nodejs.org) v18 이상 설치

---

## 설치

### 1. 저장소 클론

```bash
git clone https://github.com/Sundae-unity-dev/DailyLogHelper.git
cd DailyLogHelper
```

### 2. 설치 스크립트 실행

**Windows (PowerShell):**
```powershell
powershell -ExecutionPolicy Bypass -File install.ps1
```

**Mac / Linux / Git Bash:**
```bash
bash install.sh
```

> ℹ️ 첫 설치 시 puppeteer 가 Chromium 을 다운로드합니다 (약 300MB). 시간이 좀 걸려요.

설치가 완료되면 터미널 창은 닫아도 됩니다.

---

## 사용법

> ⚠️ 아래 명령은 터미널이 아닌 **Claude Code 입력창**에 입력하세요.
> 💡 설치 후 Claude Code 를 새로 열어야 `/일일회고` 명령이 인식됩니다.

### `/일일회고` — 대화형 (추천)

```
/일일회고
```

에이전트가 한 가지씩 차례로 묻습니다:

1. 📛 이름과 날짜
2. 🔢 **몇 차 프로젝트?** (예: `2차`, `최종`, `미니`) — 매번 새로 입력합니다
3. 📝 Scrum (오늘/진행중/내일)
4. 🛠 Project (오늘 기여한 부분)
5. 🧯 Trouble Shooting (문제와 해결)
6. 🔗 링크 (깃헙/블로그/학습)

해당 사항이 없으면 **`스킵`** 이라고 답하면 됩니다.

### `/일일회고 paste` — 일괄 모드

```
/일일회고 paste
```

오늘 작업한 내용을 메모처럼 한 번에 붙여넣으면 AI 가 자동으로 섹션 분류합니다.
부족한 정보가 있어도 그대로 PDF 가 생성됩니다. `project_order`(몇 차 프로젝트) 만 메모에 안 보이면 한 번 짧게 되묻습니다.

### `/일일회고 <메모>` — 한 줄 모드

```
/일일회고 오늘 플레이어 점프 구현했고 충돌 박스 크기 때문에 막혔는데 BoxCollider2D Size Y 를 0.5 로 줄여서 해결함
```

명령 뒤에 바로 메모를 붙이면 일괄 모드와 비슷하게 동작하지만, 정보가 너무 빈약하면 한두 가지만 짧게 되묻습니다.

### 스크린샷 / 이미지 첨부

메모 중간에 이미지 경로를 던지면 자동으로 적절한 섹션에 들어갑니다.

```
/일일회고
오늘 회의 스크럼 보드 C:\Users\me\Pictures\board.png 그리고 게임 플레이 화면 C:\Users\me\Pictures\play.png
```

- 회의·스크럼 보드 캡처 → **Scrum**
- 에디터·플레이 화면·구현 결과물 → **Project**
- 빨간 에러·콘솔 로그 → **Trouble Shooting (situation)**
- 합의된 기획안·수정 후 정상 화면 → **Trouble Shooting (resolution)**

직접 마크다운 문법으로 `![](C:\경로\screenshot.png)` 처럼 써도 같은 결과입니다.
로컬 경로 / `~/...` / `https://` URL 모두 지원합니다.

### 산출물

```
~/Desktop/일일회고/260513_2차 프로젝트_Unity 3기_홍길동.pdf
~/Desktop/일일회고/260513_2차 프로젝트_Unity 3기_홍길동.html  (검토용)
```

파일명은 노션 export 명명 규칙 (`yymmdd_{project_order} 프로젝트_Unity 3기_OOO`) 을 그대로 따릅니다. `{project_order}` 자리에는 대화 중 입력한 값(`2차`, `최종`, `미니` 등) 이 들어갑니다.
**이 PDF 를 그대로 과제 제출란에 업로드**하시면 됩니다.

---

## 파일 구성

| 파일 | 설명 |
|---|---|
| `일일회고.md` | `/일일회고` 슬래시 커맨드 정의 |
| `rules.md` | AI 정리 규칙 및 JSON 스키마 |
| `template.html` | 노션 양식 미러 HTML 템플릿 |
| `render.js` | JSON → HTML → PDF 변환 (Puppeteer) |
| `test_images/` | 레이아웃·이미지 라우팅 회귀 확인용 placeholder SVG |
| `package.json` | Node.js 의존성 |
| `install.ps1` | Windows PowerShell 설치 스크립트 |
| `install.sh` | Mac / Linux / Git Bash 설치 스크립트 |

---

## 자주 묻는 질문

**Q. PDF 가 안 만들어지고 puppeteer 오류가 떠요.**
→ 설치 디렉터리에서 의존성을 다시 설치하세요.
```
cd ~/.claude/DailyLogHelper
npm install
```

**Q. 한글 폰트가 깨져요.**
→ Windows / Mac 기본 한글 폰트(맑은 고딕 / Apple SD Gothic Neo) 가 적용됩니다. 다른 OS 라면 Noto Sans KR 을 설치해주세요.

**Q. 스크린샷을 넣고 싶어요.**
→ 메모에 `![](C:\경로\screenshot.png)` 처럼 마크다운 이미지 문법으로 적거나, 그냥 경로만 던져도 됩니다. 메모 맥락으로 어느 섹션에 들어갈지 자동 판단합니다. 로컬 경로 / `~/...` / `https://` URL 모두 지원합니다.

**Q. 파일명을 바꾸고 싶어요.**
→ 대화 도중 "파일명을 X 로 해줘" 라고 말하면 됩니다.

**Q. 1차 / 최종 / 미니 프로젝트도 쓸 수 있나요?**
→ 네. 대화형 모드에서 "🔢 몇 차 프로젝트?" 질문에 `1차`, `최종`, `미니` 등을 답하면 PDF 헤더와 파일명에 그대로 반영됩니다.

---

## 라이선스

MIT — 자세한 내용은 [LICENSE](LICENSE) 파일 참조.
