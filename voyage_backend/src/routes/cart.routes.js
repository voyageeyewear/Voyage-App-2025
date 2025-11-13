const express = require('express');
const router = express.Router();
const shopifyService = require('../services/shopify.service');

// In-memory cart storage (in production, use Redis or database)
const carts = new Map();

// Add single item to cart
router.post('/cart/add', async (req, res) => {
  try {
    const { variantId, quantity, properties } = req.body;

    if (!variantId || !quantity) {
      return res.status(400).json({
        success: false,
        message: 'variantId and quantity are required',
      });
    }

    // Create or get cart
    const cartId = req.headers['cart-id'] || Date.now().toString();
    const cart = carts.get(cartId) || { id: cartId, items: [] };

    // Add item to cart
    cart.items.push({
      id: Date.now().toString(),
      variantId,
      quantity,
      properties: properties || {},
    });

    carts.set(cartId, cart);

    res.json({
      success: true,
      cart,
      cartId,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
});

// Add multiple items to cart
router.post('/cart/add-multiple', async (req, res) => {
  try {
    const { items } = req.body;

    if (!items || !Array.isArray(items)) {
      return res.status(400).json({
        success: false,
        message: 'items array is required',
      });
    }

    // Create or get cart
    const cartId = req.headers['cart-id'] || Date.now().toString();
    const cart = carts.get(cartId) || { id: cartId, items: [] };

    // Add all items to cart
    items.forEach(item => {
      cart.items.push({
        id: Date.now().toString() + Math.random(),
        variantId: item.variantId,
        quantity: item.quantity || 1,
        properties: item.properties || {},
      });
    });

    carts.set(cartId, cart);

    res.json({
      success: true,
      cart,
      cartId,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
});

// Update cart item quantity
router.post('/cart/update', async (req, res) => {
  try {
    const { lineItemId, quantity } = req.body;
    const cartId = req.headers['cart-id'];

    if (!cartId || !lineItemId || quantity === undefined) {
      return res.status(400).json({
        success: false,
        message: 'cartId, lineItemId, and quantity are required',
      });
    }

    const cart = carts.get(cartId);
    if (!cart) {
      return res.status(404).json({
        success: false,
        message: 'Cart not found',
      });
    }

    const item = cart.items.find(i => i.id === lineItemId);
    if (item) {
      item.quantity = quantity;
    }

    res.json({
      success: true,
      cart,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
});

// Remove item from cart
router.post('/cart/remove', async (req, res) => {
  try {
    const { lineItemId } = req.body;
    const cartId = req.headers['cart-id'];

    if (!cartId || !lineItemId) {
      return res.status(400).json({
        success: false,
        message: 'cartId and lineItemId are required',
      });
    }

    const cart = carts.get(cartId);
    if (!cart) {
      return res.status(404).json({
        success: false,
        message: 'Cart not found',
      });
    }

    cart.items = cart.items.filter(i => i.id !== lineItemId);

    res.json({
      success: true,
      cart,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
});

// Get cart
router.get('/cart', async (req, res) => {
  try {
    const cartId = req.headers['cart-id'];

    if (!cartId) {
      return res.json({
        success: true,
        cart: { id: null, items: [] },
      });
    }

    const cart = carts.get(cartId) || { id: cartId, items: [] };

    res.json({
      success: true,
      cart,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
});

// Clear cart
router.post('/cart/clear', async (req, res) => {
  try {
    const cartId = req.headers['cart-id'];

    if (cartId) {
      carts.delete(cartId);
    }

    res.json({
      success: true,
      message: 'Cart cleared',
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
});

module.exports = router;

