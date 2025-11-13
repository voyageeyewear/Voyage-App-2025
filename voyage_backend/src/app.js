const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');

// Routes
const shopifyRoutes = require('./routes/shopify.routes');
const lensRoutes = require('./routes/lens.routes');
const cartRoutes = require('./routes/cart.routes');
const checkoutRoutes = require('./routes/checkout.routes');

const app = express();

// Middleware
app.use(helmet());
app.use(cors({
  origin: '*', // Allow all origins for development
  credentials: true,
}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(morgan('dev'));

// Routes
app.get('/health', (req, res) => {
  res.json({
    status: 'ok',
    timestamp: new Date().toISOString(),
    shopify: process.env.SHOPIFY_STORE_DOMAIN,
  });
});

app.use('/api/shopify', shopifyRoutes);
app.use('/api/shopify', lensRoutes);
app.use('/api/shopify', cartRoutes);
app.use('/api/shopify', checkoutRoutes);

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: 'Route not found',
  });
});

// Error handler
app.use((err, req, res, next) => {
  console.error('Error:', err);
  res.status(err.status || 500).json({
    success: false,
    message: err.message || 'Internal server error',
  });
});

module.exports = app;

