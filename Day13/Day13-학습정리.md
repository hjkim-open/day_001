# Day 13 · 모닝브루 예약 시스템 고도화

> **작업일**: 2026-06-21  
> **주제**: 관리자 대시보드 · Supabase 고급 활용 · Vercel 환경변수 분리  
> **라이브 URL**: https://day01-hjkim-opens-projects.vercel.app  
> **GitHub**: https://github.com/hjkim-open/day_001 (private)

---

## 오늘 만든 것

| 파일 | 역할 |
|---|---|
| `Day13/admin.html` | 관리자 전용 대시보드 (별도 URL) |
| `api/env.js` | Vercel 환경변수 API 라우트 |
| `Day03/index.html` | 예약 폼 전용으로 단순화 (목록 제거, 메모 추가) |

---

## 1. 아키텍처 개요

```
손님 (Day03/index.html)          사장님 (Day13/admin.html)
        │                                  │
        │  INSERT (anon)                   │  SELECT / UPDATE / DELETE
        ▼                                  ▼
  localStorage ──백업──▶  Supabase DB (reservations 테이블)
                                           │
                               /api/env ◀──┘ (환경변수 경유)
```

### 데이터 흐름
1. **손님 예약**: localStorage에 즉시 저장 → Supabase에 비동기 백업
2. **사장님 관리**: Supabase에서 직접 조회 → 상태 변경·삭제

---

## 2. Supabase 테이블 스키마

```sql
CREATE TABLE reservations (
  id               UUID        DEFAULT gen_random_uuid() PRIMARY KEY,
  name             TEXT        NOT NULL,          -- 예약자 이름
  phone            TEXT        NOT NULL,          -- 연락처
  time             TEXT        NOT NULL,          -- 픽업 시간 (HH:MM)
  count            INT         NOT NULL CHECK (count >= 1 AND count <= 20),
  menu_preference  TEXT,                          -- 메뉴 선호 (구버전 호환)
  note             TEXT,                          -- 메모 (Day13 추가)
  status           TEXT        DEFAULT 'pending', -- 예약 상태 (Day13 추가)
  created_at       TIMESTAMPTZ DEFAULT now()
);
```

### status 값 정의

| 값 | 한국어 | 색상 | 의미 |
|---|---|---|---|
| `pending` | 대기중 | 🟡 노랑 | 예약 접수, 아직 확인 전 |
| `confirmed` | 확인완료 | 🔵 파랑 | 사장님이 확인한 예약 |
| `arrived` | 방문완료 | 🟢 초록 | 손님이 실제로 방문 |
| `cancelled` | 취소 | ⚫ 회색 | 취소된 예약 |

---

## 3. RLS 정책

```sql
-- 활성화
ALTER TABLE reservations ENABLE ROW LEVEL SECURITY;

-- 손님: 예약 추가만 가능
CREATE POLICY "손님_예약_추가"
  ON reservations FOR INSERT TO anon, authenticated
  WITH CHECK (true);

-- 손님: 전체 예약 조회 (목록 표시용)
CREATE POLICY "손님_예약_조회"
  ON reservations FOR SELECT TO anon
  USING (true);

-- 사장님: 수정 (상태 변경 등)
CREATE POLICY "사장님_예약_수정"
  ON reservations FOR UPDATE TO authenticated
  USING (true) WITH CHECK (true);

-- 사장님: 삭제
CREATE POLICY "사장님_예약_삭제"
  ON reservations FOR DELETE TO authenticated
  USING (true);
```

---

## 4. Vercel 환경변수 분리

### 왜 분리하는가?

| 방식 | 문제점 |
|---|---|
| HTML 하드코딩 | GitHub에 키 노출, 키 교체 시 코드 수정 필요 |
| 환경변수 분리 | 코드와 인프라 설정 분리, 환경별(dev/prod) 독립 관리 |

### 구현: `/api/env.js`

```js
export default function handler(req, res) {
  res.json({
    supabaseUrl: process.env.SUPABASE_URL ?? "",
    supabaseAnonKey: process.env.SUPABASE_ANON_KEY ?? "",
  });
}
```

- Vercel이 `/api/` 폴더를 자동으로 **Serverless Function**으로 인식
- 환경변수는 Vercel 대시보드 → Settings → Environment Variables에서 관리
- **환경변수 변경 후 반드시 Redeploy 필요**

### HTML에서 사용하는 방법

```js
async function initSupabase() {
  const { supabaseUrl, supabaseAnonKey } = await fetch("/api/env").then(r => r.json());
  sb = createClient(supabaseUrl, supabaseAnonKey);
}
```

---

## 5. 관리자 대시보드 설계

### 화면 구성

```
┌─────────────────────────────────────────────────────┐
│ ☕ 모닝브루  │  ADMIN      날짜  [↻ 새로고침] [+ 예약 폼] │  ← 헤더 (sticky)
├────────────┬────────────┬────────────┬──────────────┤
│  오늘 예약  │   대기중   │  총 인원   │   전체 예약   │  ← 통계 카드 4종
│    3건     │   1건 🟡  │    6명     │    12건      │
├────────────┴────────────┴────────────┴──────────────┤
│ [오늘][전체]  [전체][대기중][확인완료][방문완료][취소]  🔍검색│  ← 툴바
├──────────┬──────┬───────────┬────┬────────┬────────┤
│ 픽업시간  │ 이름 │  연락처   │인원│  메모  │  상태  │  ← 테이블 헤더
├──────────┼──────┼───────────┼────┼────────┼────────┤
│ 오전 9:00│ 홍길동│010-1234-..│ 2명│ 창가자리│[대기중]│
│ 오전10:30│ 김민지│010-5678-..│ 1명│        │[확인완료│
└──────────┴──────┴───────────┴────┴────────┴────────┘
┌─────────────────────────────────────────────────────┐
│ 🟢 Supabase 연결됨 │ 대기중 1건 │ 예약 2건 │ 총 3명 │ 갱신 09:30:15 │  ← Status Bar
└─────────────────────────────────────────────────────┘
```

### 핵심 기능

#### 상태 인라인 변경
- 상태 배지 클릭 → 드롭다운 열림 → 선택 시 Supabase 즉시 UPDATE
```js
async function changeStatus(id, newStatus) {
  await sb.from("reservations").update({ status: newStatus }).eq("id", id);
}
```

#### 3중 필터
```
날짜 필터: 오늘 / 전체
상태 필터: 전체 / 대기중 / 확인완료 / 방문완료 / 취소
텍스트 검색: 이름·연락처 부분 일치
```

#### 하단 Status Bar
- VS Code 스타일의 다크 그린 고정 바
- 실시간 갱신: 연결 상태 · 대기중 건수(강조) · 총 예약 · 총 인원 · 마지막 갱신 시각
- 30초마다 Supabase에서 자동 새로고침

---

## 6. localStorage + Supabase 하이브리드 패턴

```
[예약 추가]
    │
    ├── ① localStorage 즉시 저장 → 화면 즉시 반영 (UX 우선)
    │
    └── ② Supabase INSERT (비동기, 백그라운드)
            ├── 성공 → supabaseId를 로컬 레코드에 저장
            └── 실패 → 로컬은 유지 (데이터 유실 없음)

[예약 삭제]
    │
    ├── ① localStorage에서 즉시 제거
    └── ② Supabase DELETE (비동기, supabaseId 사용)
```

**장점**: 오프라인/Supabase 장애 시에도 로컬 기능 정상 동작

---

## 7. 기억할 패턴

```
✅ Vercel Serverless Function: /api/*.js → 자동 배포
✅ 환경변수 변경 → 반드시 Redeploy
✅ RLS: ENABLE SECURITY 후 정책 없으면 전면 차단
✅ status 컬럼 기본값 'pending' → INSERT 시 명시 불필요
✅ 상태 배지 UX: 클릭 → 드롭다운 → 선택 즉시 저장
✅ Status Bar: position: fixed; bottom: 0 + z-index 높게
✅ 외부 클릭으로 드롭다운 닫기: document.addEventListener("click", ...)
```

---

## 남은 작업

| 우선순위 | 항목 | 비고 |
|---|---|---|
| 🔥 높음 | Vercel Redeploy (환경변수 적용) | Settings → Deployments → Redeploy |
| 🔥 높음 | 관리자 로그인 기능 | Supabase Auth 또는 간단한 패스워드 보호 |
| 중간 | note 필드 수정 기능 | 관리자 페이지에서 인라인 편집 |
| 낮음 | 예약 날짜 컬럼 추가 | 현재는 created_at 기준 |
| 낮음 | 알림 기능 | 새 예약 시 사장님 Push/SMS 알림 |
