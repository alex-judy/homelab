FROM forgejo.louhome.xyz/lou-home/ci-tools:74ef46087bdca13dc2cb6e75f38de78b875a2727

RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --no-cache-dir --upgrade pip && \
    /opt/venv/bin/pip install --no-cache-dir \
      yamlfix 

ENV PATH="/opt/venv/bin:${PATH}"