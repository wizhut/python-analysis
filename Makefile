default:
	@echo "Just a small Makefile to automate some stuff"
	@echo "Try one of the following targets!"
	@echo "run-analysis => download Python versions and analyze with ruff"
	@echo "uniq-violated-rules => scan files and get distinct violated PEP8 rules"

run-analysis:
	@echo "Downloading and scanning Python versions"
	@uv run gather_version_data.py

uniq-violated-rules:
	@echo "Find unique violated rules"
	@echo results/* | xargs grep ^E | cut -d : -f 2 | cut -d " " -f 1 | sort | uniq
