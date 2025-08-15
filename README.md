# etherstash
![GitHub License](https://img.shields.io/github/license/Aliyahzombie/etherstash)

An efficient and concise note-taking tool with self-hosted cloud sync support

## Usage

### Deploy Backend

1. Install Wrangler 
```bash npm install -g wrangler```
2. Login to Cloudflare 
```bash wrangler login```
3. Create a new D1 database 
```bash wrangler d1 create etherstash```
4. Go to `worker` directory and paste your D1 database id into `wrangler.toml`
5. Set up your AUTH_SECRET_KEY 
```bash wrangler secret put AUTH_SECRET_KEY```
6. Deploy 
```bash wrangler deploy```

### Enable Cloud Sync
1. Fill in your Cloudflare Worker URL and AUTH_SECRET_KEY in Settings
2. Click "Enable Cloud Sync"


## License
This repository is licensed under the AGPL-3.0 license.