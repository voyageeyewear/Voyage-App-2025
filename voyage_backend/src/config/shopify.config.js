// NOTE: Environment variables are REQUIRED for this app to work
// Create a .env file in the voyage_backend directory with:
// SHOPIFY_STORE_DOMAIN=your-store.myshopify.com
// SHOPIFY_API_KEY=your_api_key_here
// SHOPIFY_API_SECRET=your_api_secret_here
// SHOPIFY_ADMIN_ACCESS_TOKEN=your_admin_token_here
// SHOPIFY_API_VERSION=2024-07

require('dotenv').config();

module.exports = {
  storeDomain: process.env.SHOPIFY_STORE_DOMAIN,
  apiKey: process.env.SHOPIFY_API_KEY,
  apiSecret: process.env.SHOPIFY_API_SECRET,
  adminAccessToken: process.env.SHOPIFY_ADMIN_ACCESS_TOKEN,
  apiVersion: process.env.SHOPIFY_API_VERSION || '2024-07',
  
  getAdminApiUrl() {
    return `https://${this.storeDomain}/admin/api/${this.apiVersion}`;
  },
  
  getStorefrontApiUrl() {
    return `https://${this.storeDomain}/api/${this.apiVersion}/graphql.json`;
  },
};

