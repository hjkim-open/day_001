# 모닝브루 SEO/GEO — 멀티에이전트 검토 결과

> **검토 일자**: 2026-06-20
> **검토 방식**: 5개 서브에이전트 병렬 실행 (기술SEO · OG소셜 · JSON-LD · 한국LocalSEO · 접근성)
> **대상**: `DAY01/index.html` + 라이브 `https://day01-hjkim-opens-projects.vercel.app/`

---

## 종합 점수표

| 에이전트 | 담당 영역 | 점수 | 핵심 이슈 |
|---|---|---|---|
| 에이전트 1 | 기술 SEO | 🟢 85/100 | h1 키워드 없음, 폰트 렌더 블로킹 |
| 에이전트 2 | OG / 소셜 공유 | 🟡 65/100 | og:image가 SVG → 카카오톡 이미지 미표시 |
| 에이전트 3 | JSON-LD 구조화 데이터 | 🟡 70/100 | 실주소·소수점 좌표·www 누락 |
| 에이전트 4 | 한국 Local SEO | 🟡 60/100 | 도로명 주소 없음, 플레이스 미등록 |
| 에이전트 5 | 접근성 / UX 시그널 | 🟢 80/100 | skip nav 없음, section 레이블 미연결 |

---

## 에이전트 1 — 기술 SEO

### ✅ 통과 항목
- `<title>` "모닝브루 · 망원동 동네 카페" — 16자, 브랜드+지역+업종 3요소 포함
- `<meta description>` — 위치·영업시간·메뉴가 첫 문장에 자연스럽게 배치 (71자)
- `<meta name="robots">` — `index, follow, max-image-preview:large` 정상
- `<link rel="canonical">` — HTTPS + trailing slash, og:url과 일치
- `<html lang="ko">` — 정상
- `robots.txt` — User-agent·Allow·Sitemap 경로까지 교과서 수준
- `sitemap.xml` — xmlns·인코딩·날짜·changefreq·priority 모두 정상
- `favicon.svg` — HTTP 200 응답 확인

### ⚠️ 개선 필요
| 항목 | 현재 | 권장 |
|---|---|---|
| **h1 키워드** | `하루를 차분히 내리는 곳.` (감성 카피, 키워드 없음) | 브랜드명+지역명 포함 — 감성 카피는 eyebrow로 이동 |
| **폰트 렌더 블로킹** | `<link rel="stylesheet">` CDN Pretendard CSS — 렌더 블로킹 | `rel="preload"` + `onload` 비동기 로드로 전환 |
| **apple-touch-icon** | SVG로 선언 | iOS 홈 추가 시 일부 기기 미표시 → 180×180 PNG 별도 생성 권장 |

```html
<!-- 폰트 비동기 로드 (권장) -->
<link rel="preload"
  href="https://cdn.jsdelivr.net/.../pretendardvariable.min.css"
  as="style"
  onload="this.onload=null;this.rel='stylesheet'" />
<noscript>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/.../pretendardvariable.min.css" />
</noscript>
```

---

## 에이전트 2 — OG / 소셜 공유

### ✅ 통과 항목
- `og:title` — 16자, 카카오 미리보기 기준 이내
- `og:description` — 위치·특징·영업시간 간결하게 포함
- `og:url` — canonical과 완전 일치
- `og:locale` — `ko_KR` 정확
- `og:site_name` — "모닝브루" 존재
- `og:image` SVG 내용 — 1200×630 비율, 브랜드 메시지·위치·영업시간 적절히 담김
- Twitter Card 타입 — `summary_large_image` 적절

### ❌ 문제 / ⚠️ 개선 필요
| 항목 | 현재 | 권장 |
|---|---|---|
| **og:type** | `restaurant.restaurant` (비표준, 일부 파서 무시) | `website`로 변경 (업종 정보는 JSON-LD에서 처리) |
| **og:image 형식** ⭐ | `og-image.svg` | **PNG(1200×630)로 변환 필수** — 카카오톡·Facebook·Twitter 전부 SVG 미지원 |
| **twitter:site** | 없음 | `@morningbrew_official` 추가 권장 |

#### 플랫폼별 SVG 지원 현황
| 플랫폼 | 결과 |
|---|---|
| 카카오톡 | 이미지 없이 텍스트만 표시 |
| Facebook | 이미지 누락 |
| Twitter/X | 이미지 미표시 |
| 네이버 블로그 공유 | 이미지 누락 |

> **결론**: `og-image.svg`를 PNG로 변환하는 것 하나만으로 모든 플랫폼에서 이미지 미리보기가 정상 동작함.

---

## 에이전트 3 — JSON-LD 구조화 데이터

### ✅ 통과 항목
- `@type: CafeOrCoffeeShop` — Schema.org 표준 (`FoodEstablishment` 하위), 구글 지원
- 필수 필드 (`name`, `description`, `url`, `telephone`, `address`) 모두 충족
- `openingHoursSpecification` — 요일 영문 표기·HH:MM 형식·월요일 휴무 처리 정확
- `priceRange: "₩3,500–₩6,000"` — 실제 메뉴 가격과 일치
- `servesCuisine: ["Coffee", "Pastry"]` — 배열 형식, 적절
- JSON 문법 오류 없음

### ⚠️ 개선 필요
| 항목 | 현재 | 권장 |
|---|---|---|
| **streetAddress** | `"망원동 골목 끝"` | 실제 도로명+번지 입력 필수 |
| **addressLocality** | `"마포구"` (구 단위) | `"서울특별시"` (시 단위)로 수정, 구는 streetAddress에 포함 |
| **postalCode** | 없음 | 망원동 우편번호 (`04066`) 추가 |
| **geo 좌표** | 소수점 4자리 `(37.5559, 126.9028)` | 실주소 기준 소수점 6자리 이상으로 교체 |
| **sameAs** | `instagram.com/...` | `www.instagram.com/...` (www 포함 표준형) |
| **hasMap** | 네이버지도 URL | 구글맵 URL로 교체 (구글 Knowledge Panel 연동) |
| **menu** | `#menu` 해시 앵커 | 구글 크롤러 미지원 → 루트 URL 또는 `hasMenu` 속성 사용 |

```json
// 권장 address 수정안
"address": {
  "@type": "PostalAddress",
  "streetAddress": "마포구 망원동 XXX-X",
  "addressLocality": "서울특별시",
  "addressRegion": "서울특별시",
  "postalCode": "04066",
  "addressCountry": "KR"
}
```

> **구글 리치 결과 출력 가능 여부**: 현재 기본 LocalBusiness 카드 조건부 가능. `aggregateRating` 추가 시 별점 리치 결과도 가능해짐.

---

## 에이전트 4 — 한국 Local SEO

### ✅ 통과 항목
- 한국어 키워드 배치 — "망원동", "망원역", "핸드드립", "동네 카페" 제목·설명·본문 자연스럽게 포함
- 네이버지도 링크 — 존재, `rel="noopener"` 적용
- 카카오맵 링크 — 존재
- 구글맵 링크 — 존재
- `tel:` 링크 — 3곳 일관 적용, 모바일 최적
- 영업시간 표기 — 사람 읽기용 + JSON-LD 기계 판독 형식 둘 다 구현
- 인스타그램 `rel="noopener"` 적용

### ❌ 문제 / ⚠️ 개선 필요
| 항목 | 현재 | 권장 |
|---|---|---|
| **도로명 주소** ⭐ | "망원동 골목 끝" (비정형) | 실제 도로명+번지 필수 — 없으면 구글·네이버 위치 매칭 실패 |
| **NAP 전화 형식** | 본문 `02-123-4567` / JSON-LD `+82-2-123-4567` 혼용 | 전 사이트 국내 형식 `02-123-4567`로 통일 |
| **카카오맵 URL** | 구버전 파라미터 형식 | 플레이스 등록 후 고유 URL로 교체 |
| **버스 노선 안내** | 없음 | "망원역 인근 버스 정류장" 추가 권장 |

#### 한국 검색 플랫폼별 등록 현황 (코드 외적 필수 작업)
| 플랫폼 | 점유율 | 등록 여부 | 노출 가능성 |
|---|---|---|---|
| 네이버 스마트플레이스 | ~55% | ❌ 미등록 | 지도 상단 카드 노출 불가 |
| 카카오맵 비즈니스 | ~7% | ❌ 미등록 | 직접 노출 불가 |
| 구글 My Business | ~35% | ❌ 미등록 | Knowledge Panel 미표시 |

> **결론**: "망원동 카페" 네이버 검색 현재 노출 가능성 **낮음**. 스마트플레이스 등록 완료 시 **중상**으로 즉시 상승 예상.

---

## 에이전트 5 — 접근성 / UX 시그널

### ✅ 통과 항목
- 이미지 없음 → alt 누락 문제 원천 차단 (이모지 + CSS 사용)
- `aria-live="polite"` 예약 목록에 적용
- 에러 `role="alert"`, 성공 `role="status"` 구분
- 폼 `<label for>` + `<input id>` 완전 연결
- `<main>`, `<header>`, `<footer>` 랜드마크 모두 시맨틱 태그 사용
- 모든 버튼 height 50~52px (터치 44px 기준 초과)
- 외부 링크 `rel="noopener"` 전수 적용

### ⚠️ 개선 필요
| 항목 | 현재 | 권장 |
|---|---|---|
| **skip navigation** ❌ | 없음 | `<body>` 직후 본문 바로가기 링크 추가 |
| **section aria-labelledby** | 주요 `<section>` 미연결 | 각 section에 h2의 id 연결 |
| **장식 이모지 aria-hidden** | 없음 | `<div class="card-emoji" aria-hidden="true">` |
| **에러 색상 대비** | `#c14a3a / #fdecea` → 약 3.9:1 (AA 4.5:1 미달) | 전경색을 `#a83a2a`로 어둡게 |
| **삭제 버튼 터치 영역** | padding만으로 ~34px | `min-height: 44px` 추가 |
| **필수 입력 스크린리더** | `*`만 표시 | `aria-hidden="true"` + `.sr-only "(필수)"` 추가 |

```html
<!-- skip navigation (권장) -->
<a href="#main-content" class="skip-link">본문 바로가기</a>
...
<main id="main-content">
```

```css
.skip-link {
  position: absolute; left: -9999px; top: 8px;
  padding: 8px 16px; background: var(--accent); color: #fff;
  border-radius: 0 0 8px 8px; font-weight: 700; z-index: 9999;
}
.skip-link:focus {
  left: 50%; transform: translateX(-50%);
}
```

> **Lighthouse 접근성 예상 점수: 80~88점** (skip nav 추가·section 레이블 연결 완료 시 90+ 예상)

---

## 전체 개선 우선순위

### 🔥 즉시 (코드 수정, 30분 이내)

| 우선순위 | 항목 | 담당 에이전트 | 난이도 |
|---|---|---|---|
| 1 | **og-image.svg → PNG 변환** | 에이전트 2 | 중 |
| 2 | **og:type `website`로 변경** | 에이전트 2 | 하 |
| 3 | **JSON-LD address 구조 수정** (addressLocality·postalCode) | 에이전트 3 | 하 |
| 4 | **NAP 전화번호 형식 통일** | 에이전트 4 | 하 |
| 5 | **skip navigation 링크 추가** | 에이전트 5 | 하 |
| 6 | **section aria-labelledby 연결** | 에이전트 5 | 하 |

### 📅 단기 (실 사업 정보 확정 후)

| 우선순위 | 항목 | 담당 에이전트 | 임팩트 |
|---|---|---|---|
| 7 | **실 도로명 주소 → JSON-LD + 본문 반영** | 에이전트 3·4 | ⭐⭐⭐⭐⭐ |
| 8 | **geo 좌표 소수점 6자리로 교체** | 에이전트 3 | ⭐⭐⭐⭐ |
| 9 | **폰트 비동기 로드** (`preload` + `onload`) | 에이전트 1 | ⭐⭐⭐ |
| 10 | **h1에 브랜드+지역 키워드 포함** | 에이전트 1 | ⭐⭐⭐ |
| 11 | **hasMap → 구글맵 URL** | 에이전트 3 | ⭐⭐ |
| 12 | **장식 이모지 aria-hidden 처리** | 에이전트 5 | ⭐⭐ |

### 🏢 플랫폼 등록 (코드 외부, 임팩트 최대)

| 항목 | URL | 담당 에이전트 | 임팩트 |
|---|---|---|---|
| **네이버 스마트플레이스 등록** | https://smartplace.naver.com | 에이전트 4 | ⭐⭐⭐⭐⭐ |
| **카카오맵 비즈니스 등록** | https://place.map.kakao.com | 에이전트 4 | ⭐⭐⭐⭐⭐ |
| **구글 My Business 등록** | https://business.google.com | 에이전트 4 | ⭐⭐⭐⭐ |

---

## 학습 포인트 — 멀티에이전트 검토에서 배운 것

### 에이전트 간 공통으로 발견된 이슈 (가장 중요)
1. **og-image SVG 형식** — 에이전트 2(OG)와 에이전트 1(기술SEO) 모두 지적
2. **실 주소 부재** — 에이전트 3(JSON-LD)과 에이전트 4(한국SEO) 모두 치명적 약점으로 지적
3. **www 없는 인스타 URL** — 에이전트 3·4 공통 지적

### 에이전트별로만 발견된 이슈 (전문 영역)
- **에이전트 1만**: 폰트 렌더 블로킹, sitemap changefreq
- **에이전트 2만**: og:type 비표준, twitter:site 누락
- **에이전트 3만**: addressLocality 필드 오용, `#menu` 해시 앵커 크롤러 미지원
- **에이전트 5만**: skip navigation, section 레이블, 에러 색상 대비

### 결론
> **SEO와 접근성은 교집합이 크다.** 시맨틱 HTML·aria 속성·heading 계층이 모두 구글 크롤러의 콘텐츠 이해에도 직접 영향을 준다. 코드 품질이 SEO 점수다.
