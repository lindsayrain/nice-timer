## ADDED Requirements

### Requirement: GitHub release provides installable macOS assets
The project MUST publish each tagged GitHub release with macOS download assets that include a `.dmg` installer image and a `.zip` archive for the same version.

#### Scenario: Tag push creates release assets
- **WHEN** a maintainer pushes a version tag matching `v*`
- **THEN** the release workflow builds the app for that tag
- **AND** uploads a `.dmg` file and a `.zip` file to the corresponding GitHub Release

### Requirement: GitHub release page includes Traditional Chinese release content
The project MUST publish GitHub release notes in Traditional Chinese with clear download and installation guidance.

#### Scenario: Release body is loaded from version note
- **WHEN** a release is created for tag `v0.1.2`
- **THEN** the workflow loads `release-notes/v0.1.2.md` as the release body
- **AND** the content includes a Traditional Chinese feature summary and installation notes

### Requirement: GitHub release page displays screenshot context
The project MUST include at least one screenshot in the GitHub release content so users can recognize the app before downloading.

#### Scenario: Release notes render screenshot
- **WHEN** a user opens a GitHub Release page
- **THEN** the release content includes a markdown image referencing a repository screenshot asset
- **AND** the screenshot renders without depending on a feature branch path

### Requirement: Repository front page links users to stable downloads
The repository MUST direct users to the GitHub Releases page for stable version downloads.

#### Scenario: README points to releases
- **WHEN** a user visits the repository README
- **THEN** the README includes a direct link to the GitHub Releases page
- **AND** explains that `.dmg` is the recommended install format for macOS users
