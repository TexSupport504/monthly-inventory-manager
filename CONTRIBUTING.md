# Contributing to Monthly Inventory Manager

 First off, thanks for taking the time to contribute! 

The following is a set of guidelines for contributing to MIM. These are mostly guidelines, not rules. Use your best judgment, and feel free to propose changes to this document in a pull request.

## Code of Conduct

This project and everyone participating in it is governed by our [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## How Can I Contribute?

###  Reporting Bugs

Before creating bug reports, please check the [existing issues](https://github.com/TexSupport504/monthly-inventory-manager/issues) as you might find that the problem is already reported.

When you create a bug report, please use the [bug report template](.github/ISSUE_TEMPLATE/bug_report.md) and include as many details as possible:

- **Use a clear and descriptive title**
- **Describe the exact steps to reproduce the problem**
- **Provide specific examples** with sample data if possible
- **Describe the behavior you observed and what behavior you expected**
- **Include system information** (OS, Python version, etc.)
- **Add error messages and logs** if applicable

###  Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. Use the [feature request template](.github/ISSUE_TEMPLATE/feature_request.md) and provide:

- **Clear and descriptive title**
- **Step-by-step description of the suggested enhancement**
- **Explain why this enhancement would be useful**
- **List some other applications where this enhancement exists** if applicable

###  Contributing Code

#### Development Process

1. **Fork the repository** and create your branch from `main`
2. **Install development dependencies**: `pip install -r requirements-dev.txt`
3. **Make your changes** following our coding standards
4. **Add tests** for any new functionality  
5. **Run the test suite**: `python -m pytest tests/`
6. **Update documentation** if needed
7. **Submit a pull request** using our PR template

#### Branch Naming

- `feature/your-feature-name` - New features
- `bugfix/issue-description` - Bug fixes  
- `docs/update-description` - Documentation updates
- `refactor/component-name` - Code refactoring

#### Coding Standards

**Python Code:**
- Follow [PEP 8](https://pep8.org/) style guide
- Use type hints where appropriate
- Write docstrings for all public functions
- Maximum line length: 88 characters (Black formatter)

**PowerShell Scripts:**
- Use Verb-Noun naming convention
- Include comment-based help
- Handle errors gracefully with try/catch

**Documentation:**
- Use Markdown format
- Include code examples
- Keep explanations clear and concise
- Update table of contents if needed

#### Testing

- Write unit tests for new functions
- Ensure existing tests pass
- Test on multiple platforms if possible
- Include integration tests for major features

Example test structure:
```python
def test_generate_workbook():
    """Test workbook generation with sample data."""
    # Arrange
    sample_data = create_sample_data()
    
    # Act  
    result = generate_workbook(sample_data)
    
    # Assert
    assert result.success is True
    assert os.path.exists(result.output_path)
```

###  Documentation

Help improve our documentation:

- **Fix typos and improve clarity**
- **Add examples and use cases**
- **Update setup instructions**
- **Create tutorials and guides**
- **Improve API documentation**

Documentation is located in:
- `docs/` - General documentation
- `features/*/README.md` - Feature-specific docs
- `README.md` - Main project overview

## Pull Request Process

1. **Update the README.md** with details of changes if applicable
2. **Update the changelog** in `CHANGELOG.md`
3. **Ensure all tests pass** and add new tests as appropriate
4. **Request review** from maintainers
5. **Address feedback** and update your PR
6. **Squash commits** if requested before merge

### PR Template

Use our [pull request template](.github/pull_request_template.md) which includes:

- **Description** of changes
- **Type of change** (bug fix, feature, docs, etc.)
- **Testing performed**
- **Checklist** to verify completion

## Feature Development Guidelines

### Adding New Features

1. **Discuss major changes** by opening an issue first
2. **Create feature branch**: `feature/your-feature-name`  
3. **Follow the project structure**:
   ```
   features/your-feature/
    README.md           # Feature documentation
    __init__.py         # Feature module
    main_module.py      # Core functionality
    tests/              # Feature tests
    docs/               # Additional docs
   ```
4. **Update main README** to include your feature
5. **Add configuration options** to `config.yaml` if needed

### Power BI Components

When contributing Power BI related features:

- **Follow MCCNO branding** guidelines
- **Test with sample data** provided
- **Document DAX measures** with comments
- **Include screenshot placeholders** in documentation
- **Validate theme compatibility**

### Excel Integration

For Excel-related contributions:

- **Use openpyxl** for xlsx manipulation
- **Test cross-platform compatibility**  
- **Handle large datasets efficiently**
- **Provide template examples**
- **Document required columns/formats**

## Community Guidelines

### Communication

- **Be respectful and inclusive** in all interactions
- **Use clear, descriptive language** in issues and PRs
- **Provide context and examples** when asking questions
- **Help newcomers** get started with the project

### Recognition

Contributors are recognized in:
- **Contributors section** of README.md
- **Changelog entries** for significant contributions
- **Release notes** for major features

## Development Environment

### Setup

```bash
# Fork and clone
git clone https://github.com/YOUR-USERNAME/monthly-inventory-manager.git
cd monthly-inventory-manager

# Create virtual environment
python -m venv venv
source venv/bin/activate  # Linux/macOS
# or
venv\Scripts\activate     # Windows

# Install development dependencies
pip install -r requirements-dev.txt

# Install pre-commit hooks
pre-commit install

# Run setup assistant
python tools/setup-assistant/setup.py

# Run tests
python -m pytest tests/
```

### Development Tools

We use these tools to maintain code quality:

- **Black** - Code formatting
- **isort** - Import sorting  
- **flake8** - Linting
- **mypy** - Type checking
- **pytest** - Testing
- **pre-commit** - Git hooks

### Pre-commit Hooks

Our pre-commit configuration checks:

- Code formatting (Black, isort)
- Linting (flake8)
- Type hints (mypy)  
- Trailing whitespace
- End of file newlines
- JSON/YAML validity
- Markdown linting

## Questions?

-  **Check documentation** in `docs/` first
-  **Search existing issues** for similar questions
-  **Start a discussion** for general questions
-  **Open an issue** for specific problems

## Thank You!

Your contributions make MIM better for everyone. Whether you fix a typo, add a feature, or help another user, every contribution is valuable.

---

**Happy contributing! **
