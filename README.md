# Training Results Dashboard

Interactive dashboard for viewing training job results with detailed metrics, charts, and per-class analysis.

## Features

- **Overview Dashboard**: Summary of all training jobs grouped by dataset
- **Interactive Charts**: mAP, loss curves, precision/recall with Chart.js
- **Per-Class Metrics**: Detailed breakdown by class with filtering and sorting
- **Job Detail View**: Full training history with debug metrics
- **Responsive Design**: Works on desktop and mobile

## Deploy to Vercel

### Option 1: Using Vercel CLI

```bash
# Install Vercel CLI if not already installed
npm i -g vercel

# Navigate to visualization folder
cd visualization

# Deploy
vercel
```

### Option 2: Using Git

1. Push the `visualization` folder to a Git repository
2. Import the repository on [vercel.com](https://vercel.com)
3. Vercel will auto-detect the static site configuration

### Option 3: Manual Upload

1. Go to [vercel.com](https://vercel.com)
2. Click "Add New Project"
3. Select "Import Git Repository" or upload the folder directly

## Local Development

```bash
# Using Python
python serve.py

# Or using Node.js
npx serve .

# Or using PHP
php -S localhost:8000
```

Then open http://localhost:8080

## Data Structure

The dashboard reads from:
- `api_jobs/by_dataset.json` - Grouped job summaries
- `api_jobs/datasets.json` - Dataset metadata including class names
- `api_jobs/jobs/*.json` - Individual job details with training history

## File Structure

```
visualization/
├── index.html          # Main dashboard
├── detail.html         # Job detail view
├── vercel.json         # Vercel deployment config
├── api_jobs/           # API data (JSON)
│   ├── by_dataset.json
│   ├── datasets.json
│   └── jobs/
│       └── *.json
└── serve.py           # Local dev server (optional)
```

## Notes

- The dashboard uses client-side rendering with vanilla JavaScript
- Chart.js is loaded from CDN
- Tailwind CSS is loaded from CDN
- All data is static JSON files
