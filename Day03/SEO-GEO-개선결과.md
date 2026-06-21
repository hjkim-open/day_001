# 모닝브루 SEO/GEO 개선 결과

> **작업일**: 2026-06-20
> **대상 파일**: `DAY01/index.html`
> **라이브 URL**: https://day01-hjkim-opens-projects.vercel.app
> **GitHub**: https://github.com/hjkim-open/day_001 (private)
> **커밋**: `feat: SEO/GEO 개선 — OG·JSON-LD·favicon·sitemap·지도링크`

---

## 진단 점수 (작업 전 → 후)

| 영역 | 전 | 후 |
|---|---|---|
| 기본 SEO | 🟡 4/10 | 🟢 8/10 |
| 소셜 공유 (OG) | 🔴 0/10 | 🟢 9/10 |
| 구조화 데이터 | 🔴 0/10 | 🟢 9/10 |
| Local SEO (구글) | 🔴 1/10 | 🟢 7/10 |
| Local SEO (한국) | 🔴 0/10 | 🟡 5/10 |
| 기술 SEO | 🟡 6/10 | 🟢 9/10 |

> Local SEO(한국) 5점 이유: 네이버·카카오 플레이스 등록은 사이트 외부 작업이라 코드로 완결 불가

---

## 적용 항목

### 1. `<head>` 메타 개선

#### meta description 강화
```html
<!-- 전: 가게 소개 한 줄 -->
<meta name="description" content="망원동 골목 끝의 작은 동네 카페 모닝브루 — 매일 아침 직접 내리는 핸드드립과 당일 구운 수제 스콘." />

<!-- 후: 위치·시간 키워드 앞에 배치 -->
<meta name="description" content="망원역 2번 출구 도보 6분 · 화~일 08:00–20:00 · 매일 아침 직접 내리는 핸드드립과 당일 구운 수제 스콘. 망원동 골목 끝의 작은 동네 카페 모닝브루." />
```

#### 기술 SEO
```html
<meta name="robots" content="index, follow, max-image-preview:large" />
<link rel="canonical" href="https://day01-hjkim-opens-projects.vercel.app/" />
```

#### Favicon & 앱 아이콘
```html
<link rel="icon" type="image/svg+xml" href="/favicon.svg" />
<link rel="apple-touch-icon" href="/favicon.svg" />
<meta name="theme-color" content="#2f7a4f" />
```

#### Open Graph (카카오톡·인스타·문자 공유 미리보기)
```html
<meta property="og:type" content="restaurant.restaurant" />
<meta property="og:title" content="모닝브루 · 망원동 동네 카페" />
<meta property="og:description" content="망원역 2번 출구 도보 6분. 매일 아침 직접 내리는 핸드드립과 당일 구운 수제 스콘. 화~일 08:00–20:00." />
<meta property="og:image" content="https://day01-hjkim-opens-projects.vercel.app/og-image.svg" />
<meta property="og:image:width" content="1200" />
<meta property="og:image:height" content="630" />
<meta property="og:url" content="https://day01-hjkim-opens-projects.vercel.app/" />
<meta property="og:locale" content="ko_KR" />
<meta property="og:site_name" content="모닝브루" />
```

#### Twitter Card
```html
<meta name="twitter:card" content="summary_large_image" />
<meta name="twitter:title" content="모닝브루 · 망원동 동네 카페" />
<meta name="twitter:description" content="망원역 2번 출구 도보 6분. 매일 아침 핸드드립, 당일 구운 수제 스콘." />
<meta name="twitter:image" content="https://day01-hjkim-opens-projects.vercel.app/og-image.svg" />
```

#### LocalBusiness JSON-LD (구조화 데이터)
- `@type: CafeOrCoffeeShop`
- 영업시간 기계 판독 가능 (`OpeningHoursSpecification`)
- 위경도 `GeoCoordinates` (37.5559, 126.9028 — 망원동 근사값, 실측 필요)
- 전화·주소·메뉴 URL·인스타 `sameAs` 포함

---

### 2. HTML 구조 개선

#### #contact 섹션 heading 계층 수정
```html
<!-- 전: h2 없이 h3부터 시작 -->
<section id="contact" class="container">
  <div class="cta-card">
    <h3>오늘 한 잔...</h3>

<!-- 후: h2 추가로 계층 완성 -->
<section id="contact" class="container">
  <h2 class="section-title">예약 · 문의</h2>
  <p class="section-sub">인스타그램 DM, 전화, 또는 아래 온라인 예약으로 연락주세요.</p>
  <div class="cta-card">
    <h3>오늘 한 잔...</h3>
```

#### 오시는 길 섹션 — 지도 링크 추가
- 🟢 네이버지도 → `map.naver.com/p/search/모닝브루 망원동`
- 🟡 카카오맵 → `map.kakao.com/?q=모닝브루 망원동`
- 🔵 구글맵 → `google.com/maps/search/모닝브루+망원동`

---

### 3. 신규 파일 (4개)

| 파일 | 역할 | 비고 |
|---|---|---|
| `favicon.svg` | 브라우저 탭·북마크 아이콘 | 커피잔 SVG, 그린 배경 |
| `og-image.svg` | SVG 원본 | 디자인 소스 보존용 |
| `og-image.png` | 카톡·SNS 공유 미리보기 이미지 | 1200×630, 47KB, 카카오·SNS 완전 호환 ✅ |
| `robots.txt` | 검색 크롤러 안내 | Sitemap 경로 포함 |
| `sitemap.xml` | 검색엔진 페이지 목록 | changefreq: monthly |

---

## 남은 작업 (사이트 외부 — 직접 해야 함)

### ✅ 2차 개선 적용 완료 (멀티에이전트 리뷰 반영, 2026-06-20)

| 항목 | 상태 | 내용 |
|---|---|---|
| og:type 수정 | ✅ 완료 | `restaurant.restaurant` → `website` |
| og-image PNG 변환 | ✅ 완료 | `og-image.png` 1200×630 47KB 생성, 카카오 호환 |
| JSON-LD 주소 계층 | ✅ 완료 | addressLocality=서울특별시, addressRegion=마포구, postalCode 추가 |
| JSON-LD hasMap | ✅ 완료 | 네이버 → 구글맵 URL로 교체 |
| NAP 전화번호 통일 | ✅ 완료 | `+82-2-123-4567` → `02-123-4567` |
| Skip navigation | ✅ 완료 | `<a href="#main-content">본문 바로가기</a>` |
| section aria-labelledby | ✅ 완료 | 5개 섹션 전체 적용 |
| 데코레이티브 이모지 | ✅ 완료 | feature-ico 4개 `aria-hidden="true"` |
| Pretendard 비동기 로딩 | ✅ 완료 | `rel=preload` + onload 패턴 |

### 남은 작업 (사이트 외부 — 직접 해야 함)

| 우선순위 | 항목 | URL | 임팩트 |
|---|---|---|---|
| 🔥 최우선 | **네이버 스마트플레이스 등록** | https://smartplace.naver.com | ⭐⭐⭐⭐⭐ |
| 🔥 최우선 | **카카오맵 비즈니스 등록** | https://map.kakao.com | ⭐⭐⭐⭐⭐ |
| 높음 | **구글 My Business 등록** | https://business.google.com | ⭐⭐⭐⭐ |
| 중간 | 실제 주소·전화·위경도 반영 | JSON-LD 수정 (플레이스홀더 교체) | ⭐⭐⭐ |
| 낮음 | 커스텀 도메인 구매·연결 | Vercel 대시보드 | ⭐⭐ |

---

## 핵심 개념 정리

### SEO (Search Engine Optimization)
검색엔진(구글·네이버)에서 내 페이지가 잘 검색되도록 최적화하는 작업.
- **기술 SEO**: 크롤링 가능한 구조, canonical, robots, sitemap
- **콘텐츠 SEO**: 제목·설명·키워드의 자연스러운 배치
- **Core Web Vitals**: 로딩속도·반응성·시각 안정성

### GEO (Geographic / Local SEO)
"망원동 카페" 같은 지역 검색에서 노출되도록 최적화하는 작업.
- **NAP 일관성**: Name·Address·Phone을 모든 플랫폼에 동일하게 유지
- **구조화 데이터**: `LocalBusiness` JSON-LD로 구글에 기계 판독 가능하게 전달
- **지도 플랫폼 등록**: 네이버·카카오·구글에 직접 등록 (코드보다 이게 더 중요)

### OG (Open Graph)
카카오톡·인스타·슬랙 등에서 링크를 공유할 때 제목·설명·이미지가 미리보기로 뜨게 하는 메타 태그.
- `og:image` 권장 규격: 1200×630px, 1MB 이하, PNG/JPEG (카카오는 SVG 미지원)

---

## 기억할 패턴

```
1페이지 카페 사이트 SEO 체크리스트
☑ <html lang="ko">
☑ <title> — 브랜드명 + 지역 + 업종
☑ <meta description> — 위치·시간 앞에 배치
☑ OG 6종 + og:type=website + og:image=PNG
☑ Twitter Card
☑ canonical
☑ robots
☑ favicon.svg + apple-touch-icon + theme-color
☑ LocalBusiness JSON-LD (영업시간·위경도·주소계층 포함)
☑ 네이버·카카오·구글맵 링크 (오시는 길 섹션)
☑ robots.txt (Sitemap 경로 포함)
☑ sitemap.xml
☑ Skip navigation 링크
☑ section aria-labelledby
☑ 폰트 비동기 로딩 (렌더 블로킹 제거)
□ [외부] 네이버 스마트플레이스 등록
□ [외부] 카카오맵 비즈니스 등록
□ [외부] 구글 My Business 등록
□ [실측] 실제 주소·전화·위경도로 JSON-LD 업데이트
```
