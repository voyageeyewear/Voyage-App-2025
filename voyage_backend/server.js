require('dotenv').config();
const app = require('./src/app');

const PORT = process.env.PORT || 3000;
const HOST = '0.0.0.0'; // Railway requires binding to 0.0.0.0

app.listen(PORT, HOST, () => {
  console.log('=================================');
  console.log(`🚀 Voyage Backend Server Running`);
  console.log(`📍 Port: ${PORT}`);
  console.log(`🌐 Host: ${HOST}`);
  console.log(`🌍 Environment: ${process.env.NODE_ENV}`);
  console.log(`🏪 Shopify Store: ${process.env.SHOPIFY_STORE_DOMAIN}`);
  console.log('=================================');
});

