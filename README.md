# Econ Research Bundle

Bộ trợ lý AI giúp viết bài nghiên cứu kinh tế định lượng, từ chọn đề tài, tổng quan tài liệu, chạy hồi quy, viết từng chương, kiểm tra trích dẫn, phản biện thử, đến làm slide và chuẩn bị Q&A.

Dùng được trên **Gemini, ChatGPT và Claude**, cả bản app/web lẫn bản dòng lệnh.

## Chọn cách dùng

| Bạn dùng | Cách cài | Cần terminal? |
|---|---|---|
| **Gemini app / web** (gemini.google.com) | [A. Tạo Gem](#a-gemini-app-tạo-gem) | Không |
| **ChatGPT web / app** | [B. Tạo Project hoặc GPT](#b-chatgpt-tạo-project-hoặc-gpt) | Không |
| **Claude.ai** | [C. Tạo Project hoặc tải Skill](#c-claudeai) | Không |
| Claude Code, Codex CLI, ChatGPT desktop, Gemini CLI | [D. Cài skill đầy đủ](#d-cài-skill-đầy-đủ-cho-agent-dòng-lệnh) | Có |

Bản app (A, B, C) dùng 2 file trong thư mục [`chat/`](chat):
- [`INSTRUCTIONS.md`](chat/INSTRUCTIONS.md): phần hướng dẫn, dán vào ô instructions.
- [`econ-paper-playbook.md`](chat/econ-paper-playbook.md): quy trình chi tiết và code R/Stata, tải lên làm tài liệu (knowledge).

Bản dòng lệnh (D) dùng bộ skill đầy đủ trong [`skills/`](skills), mạnh hơn nhưng cần cài.

---

### A. Gemini app: tạo Gem

1. Tải repo về: bấm nút xanh **Code > Download ZIP**, rồi giải nén.
2. Vào [gemini.google.com](https://gemini.google.com), mở **Gem manager** (Trình quản lý Gem) ở thanh bên, bấm **New Gem** (Gem mới).
3. **Name:** `Econ Research Assistant`.
4. **Instructions:** mở `chat/INSTRUCTIONS.md`, copy toàn bộ, dán vào.
5. **Knowledge:** tải lên `chat/econ-paper-playbook.md`. Nếu Gemini không nhận file `.md`, đổi đuôi thành `.txt` rồi tải lại.
6. Bấm **Save**. Mỗi lần dùng, mở Gem này và nhắn ví dụ: *"Nhóm mình cần chọn đề tài vĩ mô, đây là yêu cầu của thầy: ..."*

Muốn cả nhóm dùng chung: trong Gem manager, bấm chia sẻ Gem cho các thành viên (nếu tài khoản có tùy chọn này). Nếu không, mỗi người tự làm 6 bước trên, mất khoảng 2 phút.

### B. ChatGPT: tạo Project hoặc GPT

**Cách 1: Project** (dùng được cả tài khoản miễn phí)
1. Ở thanh bên ChatGPT, bấm **New project**, đặt tên `Econ Research`.
2. Mở **Instructions** của project, dán nội dung `chat/INSTRUCTIONS.md`.
3. Mở **Files**, tải lên `chat/econ-paper-playbook.md`.
4. Mọi đoạn chat mở trong project này sẽ dùng các hướng dẫn trên.

**Cách 2: Custom GPT** (cần tài khoản trả phí để tạo, nhưng chia sẻ link được cho cả nhóm)
1. **Explore GPTs > Create > Configure**.
2. **Instructions:** dán `chat/INSTRUCTIONS.md`. File dưới 8000 ký tự nên vừa giới hạn.
3. **Knowledge:** tải lên `chat/econ-paper-playbook.md`. Bật **Web Search** để GPT kiểm tra được trích dẫn.
4. **Create**, chọn **Anyone with the link**, rồi gửi link cho nhóm.

### C. Claude.ai

**Cách 1: Project**
1. **Projects > Create project**.
2. **Project instructions:** dán `chat/INSTRUCTIONS.md`.
3. **Project knowledge:** tải lên `chat/econ-paper-playbook.md`.

**Cách 2: Skills** (nếu tài khoản có mục Skills trong **Settings > Capabilities**)
1. Vào trang [Releases](../../releases/latest) của repo, tải các file `.zip` (mỗi skill một file).
2. **Settings > Capabilities > Skills > Upload skill**, tải lên từng file zip. Nên tải `econ-research.zip` cùng các skill nó gọi.

### D. Cài skill đầy đủ cho agent dòng lệnh

```bash
git clone https://github.com/golducker/econ-research-bundle.git
cd econ-research-bundle
```

macOS / Linux / Git Bash:
```bash
./install.sh all
```

Windows PowerShell:
```powershell
powershell -ExecutionPolicy Bypass -File install.ps1 all
```

Thay `all` bằng `claude`, `codex` hoặc `gemini` nếu chỉ cần một nền tảng:

| Tham số | Cài vào | Dùng cho |
|---|---|---|
| `claude` | `~/.claude/skills` | Claude Code |
| `codex` | `~/.agents/skills` | Codex CLI, ChatGPT desktop app |
| `gemini` | `~/.gemini/skills` | Gemini CLI (bật Agent Skills trong settings nếu được yêu cầu) |

Sau khi cài, khởi động lại agent và gõ `/econ-research` (Claude Code) hoặc nhắn *"dùng skill econ-research"*.

---

## Các bước trợ lý hỗ trợ

| # | Bạn đang ở bước | Skill (bản D) |
|---|---|---|
| 1 | Mới có ý tưởng, cần chọn đề tài và câu hỏi nghiên cứu | `deep-research` (socratic) |
| 2 | Tổng quan tài liệu | `deep-research` (lit-review) |
| 3 | Sàng lọc bài báo theo tiêu chí | `sr-screener` |
| 4 | Chạy hồi quy panel, IV, DiD, RDD trong R | `r-econometrics` |
| 5 | Lập đề cương | `academic-paper` (plan) |
| 6 | Viết nháp, tóm tắt, kiểm tra trích dẫn | `academic-paper` |
| 7 | Phản biện thử bản nháp | `academic-paper-reviewer` |
| 8 | Sửa bài theo nhận xét của thầy | `academic-paper` (revision) |
| 9 | Làm trọn quy trình từ ý tưởng đến bài hoàn chỉnh | `academic-pipeline` |

Bản app (A, B, C) gom các bước này vào một menu 10 mục, hiện ra khi bạn mở chat mà chưa nói cần gì.

## Lưu ý khi dùng cho bài có chấm điểm

- **Không tin trích dẫn AI đưa ra khi chưa tự mở nguồn.** Bộ hướng dẫn đã cấm bịa nguồn, nhưng vẫn phải kiểm tra lại trên Google Scholar.
- **Số liệu trong phần Kết quả phải lấy từ output nhóm tự chạy.** Dán output vào chat để AI giải thích, không nhờ AI "đoán" kết quả.
- **Y là biến phụ thuộc (bị ảnh hưởng), X là biến độc lập (tác động).** Giữ ký hiệu thống nhất ở mọi chương.
- Ghi chú việc dùng AI theo quy định của môn học.
- Cả nhóm nên hiểu toàn bộ bài. Dùng mục 10 trong menu để luyện Q&A chéo phần.

## Nguồn và giấy phép

Năm skill `academic-*`, `deep-research` và `sr-screener` là của **Cheng-I Wu** ([academic-research-skills](https://github.com/Imbad0202/academic-research-skills)), theo giấy phép **CC BY-NC 4.0**: chỉ dùng phi thương mại và phải ghi nguồn. `r-econometrics` lấy từ [awesome-econ-ai-stuff](https://github.com/meleantonio/awesome-econ-ai-stuff), giấy phép CC0. Chi tiết và danh sách thay đổi xem trong [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).
