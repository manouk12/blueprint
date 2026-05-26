# scripts/bootstrap-blueprint.ps1
# AI 컨텍스트 뼈대 및 페르소나 자동 이식 스크립트

param (
    [string]$ProjectRoot
)

$ErrorActionPreference = "Stop"

# 배치 파일이 넘겨준 최상단 절대 경로 인수가 없으면 자율 추적을 가동한다요!
if ([string]::IsNullOrEmpty($ProjectRoot)) {
    if ($PSScriptRoot) {
        $ProjectRoot = Split-Path $PSScriptRoot -Parent
    } else {
        $ProjectRoot = Split-Path (Split-Path $pwd -Parent) -Parent
    }
}

# 쌍따옴표, 홑따옴표, 끝 백슬래시 등을 강제 트리밍하여 윈도우 이스케이프 오류를 완벽히 막는다요!
$ProjectRoot = $ProjectRoot.Trim().Trim('"').Trim("'").TrimEnd('\')
$ProjectName = Split-Path $ProjectRoot -Leaf

Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "Copying AI Context Pack and Personas..." -ForegroundColor Cyan
Write-Host "Project Root: $ProjectRoot" -ForegroundColor Yellow
Write-Host "Project Name: $ProjectName" -ForegroundColor Yellow
Write-Host "==============================================" -ForegroundColor Cyan

# 2. 필요한 docs 디렉토리 스캐폴딩 (순수 문자열 병합 방식으로 Join-Path 오류 원천 차단!)
$DocsDir = "${ProjectRoot}\docs"
$AiContextDir = "${DocsDir}\.ai-context"
$PersonaDir = "${DocsDir}\persona"
$ArchDocsDir = "${DocsDir}\architect_docs"

$Directories = @($AiContextDir, $PersonaDir, $ArchDocsDir)

foreach ($Dir in $Directories) {
    if (-not (Test-Path $Dir)) {
        New-Item -ItemType Directory -Path $Dir -Force | Out-Null
        Write-Host "Created Directory: $Dir" -ForegroundColor Green
    }
}

# 3. 템플릿 소스 경로 지정 (순수 문자열 병합 방식으로 Join-Path 오류 원천 차단!)
$TemplateRoot = "${ProjectRoot}\templates"
$TemplateBlueprint = "${TemplateRoot}\AI_BLUEPRINT_v0.2_20260519.md"
$TemplatePersonaDir = "${TemplateRoot}\persona"

# 4. 페르소나 마스터 파일들 강제 복사
if (Test-Path $TemplatePersonaDir) {
    Copy-Item -Path "${TemplatePersonaDir}\*" -Destination $PersonaDir -Force -Recurse
    Write-Host "Success: Personas copied successfully." -ForegroundColor Green
} else {
    Write-Warning "Warning: Persona templates not found: $TemplatePersonaDir"
}

# 5. 블루프린트 v0.2 마스터 파일 복사
if (Test-Path $TemplateBlueprint) {
    $DestBlueprint = "${AiContextDir}\AI_BLUEPRINT_v0.2_20260519.md"
    Copy-Item -Path $TemplateBlueprint -Destination $DestBlueprint -Force
    Write-Host "Success: AI Blueprint v0.2 copied successfully." -ForegroundColor Green
} else {
    Write-Warning "Warning: Blueprint template not found: $TemplateBlueprint"
}

Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "AI Onboarding Files Setup Completed Successfully!" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan
