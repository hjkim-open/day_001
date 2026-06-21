-- ============================================================
-- 모닝브루 예약 테이블 생성 + RLS 정책
-- 대상 DB : Supabase (Postgres)
-- 작성일  : 2026-06-21
-- ============================================================

-- ── 1. 테이블 생성 ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS reservations (
  id               UUID        DEFAULT gen_random_uuid() PRIMARY KEY,
  name             TEXT        NOT NULL,
  phone            TEXT        NOT NULL,
  menu_preference  TEXT,
  time             TEXT        NOT NULL,
  count            INT         NOT NULL CHECK (count >= 1 AND count <= 20),
  created_at       TIMESTAMPTZ DEFAULT now()
);

-- ── 2. RLS 활성화 ──────────────────────────────────────────
--  활성화하면 정책이 없는 role은 아무것도 할 수 없음
ALTER TABLE reservations ENABLE ROW LEVEL SECURITY;

-- ── 3. 정책 (Policy) ───────────────────────────────────────

-- [손님] 예약 추가
--  · 카페 웹사이트 방문자(anon)가 예약 폼을 제출하면 INSERT
--  · SELECT 권한 없음 → 다른 손님 예약 정보 열람 불가
CREATE POLICY "손님_예약_추가"
  ON reservations
  FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);

-- [사장님] 전체 예약 조회
--  · 로그인한 사용자(authenticated = 사장님)만 전체 목록 열람
CREATE POLICY "사장님_예약_조회"
  ON reservations
  FOR SELECT
  TO authenticated
  USING (true);

-- [사장님] 예약 수정
--  · 픽업시간·인원 변경 등 운영 중 수정이 필요한 경우
CREATE POLICY "사장님_예약_수정"
  ON reservations
  FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- [사장님] 예약 삭제
--  · 노쇼·취소 처리
CREATE POLICY "사장님_예약_삭제"
  ON reservations
  FOR DELETE
  TO authenticated
  USING (true);

-- ── 4. 인덱스 (조회 성능) ─────────────────────────────────
--  사장님 대시보드: 날짜순 정렬이 가장 잦은 패턴
CREATE INDEX IF NOT EXISTS idx_reservations_created_at
  ON reservations (created_at DESC);

--  픽업 시간(time) 기준 정렬도 자주 사용
CREATE INDEX IF NOT EXISTS idx_reservations_time
  ON reservations (time);

-- ── 5. 동작 확인용 쿼리 (실행 전 검토용 주석) ─────────────
-- 정책 목록 확인
-- SELECT policyname, cmd, roles, qual, with_check
-- FROM pg_policies
-- WHERE tablename = 'reservations';

-- anon 키로 INSERT 테스트 (웹 예약 폼 시뮬레이션)
-- INSERT INTO reservations (name, phone, time, count, menu_preference)
-- VALUES ('홍길동', '010-1234-5678', '08:30', 2, '핸드드립 에티오피아');

-- authenticated 키로 SELECT 테스트 (사장님 대시보드)
-- SELECT * FROM reservations ORDER BY created_at DESC;
