FROM python:3.12-slim
COPY frequency.py update_results.sh entrypoint.sh /action/
RUN chmod +x /action/*.sh
ENTRYPOINT ["/action/entrypoint.sh"]
