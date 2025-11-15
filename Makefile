default:
	@echo "Just a small Makefile to automate some stuff"
	@echo "Try one of the following targets!"
	@echo "run-analysis => download Python versions and analyze with ruff"
	@echo "uniq-violated-rules => scan files and get distinct violated PEP8 rules"
	@echo "average-error-count => calculate the average error count per major version"

run-analysis:
	@echo "Downloading and scanning Python versions"
	@uv run gather_version_data.py

uniq-violated-rules:
	@echo "Find unique violated rules"
	@echo results/* | xargs grep ^E | cut -d : -f 2 | cut -d " " -f 1 | sort | uniq

average-error-count:
	@echo "Calculate average errors per file"
	@ls results/Python-3.0.*.text | xargs grep ^Found | awk '{sum += $$2; count++} END {print "3.0.*: avg Errors:", sum}'
	@ls results/Python-3.1.*.text | xargs grep ^Found | awk '{sum += $$2; count++} END {print "3.1.*: avg Errors:", sum / count}'
	@ls results/Python-3.2.*.text | xargs grep ^Found | awk '{sum += $$2; count++} END {print "3.2.*: avg Errors:", sum / count}'
	@ls results/Python-3.3.*.text | xargs grep ^Found | awk '{sum += $$2; count++} END {print "3.3.*: avg Errors:", sum / count}'
	@ls results/Python-3.4.*.text | xargs grep ^Found | awk '{sum += $$2; count++} END {print "3.4.*: avg Errors:", sum / count}'
	@ls results/Python-3.5.*.text | xargs grep ^Found | awk '{sum += $$2; count++} END {print "3.5.*: avg Errors:", sum / count}'
	@ls results/Python-3.6.*.text | xargs grep ^Found | awk '{sum += $$2; count++} END {print "3.6.*: avg Errors:", sum / count}'
	@ls results/Python-3.7.*.text | xargs grep ^Found | awk '{sum += $$2; count++} END {print "3.7.*: avg Errors:", sum / count}'
	@ls results/Python-3.8.*.text | xargs grep ^Found | awk '{sum += $$2; count++} END {print "3.8.*: avg Errors:", sum / count}'
	@ls results/Python-3.9.*.text | xargs grep ^Found | awk '{sum += $$2; count++} END {print "3.9.*: avg Errors:", sum / count}'
	@ls results/Python-3.10.*.text | xargs grep ^Found | awk '{sum += $$2; count++} END {print "3.10.*: avg Errors:", sum / count}'
	@ls results/Python-3.11.*.text | xargs grep ^Found | awk '{sum += $$2; count++} END {print "3.11.*: avg Errors:", sum / count}'
	@ls results/Python-3.12.*.text | xargs grep ^Found | awk '{sum += $$2; count++} END {print "3.12.*: avg Errors:", sum / count}'
	@ls results/Python-3.13.*.text | xargs grep ^Found | awk '{sum += $$2; count++} END {print "3.13.*: avg Errors:", sum / count}'
	@ls results/Python-3.14.*.text | xargs grep ^Found | awk '{sum += $$2; count++} END {print "3.14.*: avg Errors:", sum}'

