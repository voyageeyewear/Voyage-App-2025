const express = require('express');
const router = express.Router();
const shopifyService = require('../services/shopify.service');

// Transform product for app
function transformProduct(product) {
  const variant = product.variants && product.variants[0];
  
  return {
    id: product.id.toString(),
    title: product.title,
    handle: product.handle,
    description: product.body_html || '',
    images: product.images ? product.images.map(img => ({ url: img.src })) : [],
    priceRange: {
      minVariantPrice: {
        amount: variant ? variant.price : '0',
      },
      maxVariantPrice: {
        amount: variant ? variant.price : '0',
      },
    },
    compareAtPriceRange: variant && variant.compare_at_price ? {
      minVariantPrice: {
        amount: variant.compare_at_price,
      },
    } : null,
    variants: product.variants ? product.variants.map(v => ({
      id: v.id.toString(),
      title: v.title,
      price: {
        amount: v.price,
      },
      compareAtPrice: v.compare_at_price ? {
        amount: v.compare_at_price,
      } : null,
      availableForSale: v.inventory_quantity > 0,
      quantityAvailable: v.inventory_quantity || 0,
      sku: v.sku,
      selectedOptions: {},
    })) : [],
    availableForSale: variant ? variant.inventory_quantity > 0 : product.availableForSale || false,
    tags: Array.isArray(product.tags) ? product.tags : (product.tags ? product.tags.split(',').map(t => t.trim()) : []),
    vendor: product.vendor,
  };
}

// Get products
router.get('/products', async (req, res) => {
  try {
    const limit = parseInt(req.query.limit) || 50;
    
    // Try Shopify first, fallback to demo products if it fails
    let products;
    try {
      products = await shopifyService.getProducts(limit);
    } catch (shopifyError) {
      console.log('Shopify API failed, using demo products:', shopifyError.message);
      // Load demo products
      const fs = require('fs');
      const path = require('path');
      const demoPath = path.join(__dirname, 'demo_products.json');
      products = JSON.parse(fs.readFileSync(demoPath, 'utf8'));
    }
    
    const transformedProducts = products.map(transformProduct);
    
    res.json({
      success: true,
      products: transformedProducts,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
});

// Get single product
router.get('/products/:id', async (req, res) => {
  try {
    const product = await shopifyService.getProductById(req.params.id);
    
    res.json({
      success: true,
      product: transformProduct(product),
    });
  } catch (error) {
    res.status(404).json({
      success: false,
      message: error.message,
    });
  }
});

// Get collections
router.get('/collections', async (req, res) => {
  try {
    const collections = await shopifyService.getCollections();
    
    const transformedCollections = collections.map(col => ({
      id: col.id.toString(),
      title: col.title,
      handle: col.handle,
      description: col.body_html,
      image: col.image ? col.image.src : null,
      productsCount: col.products_count || 0,
    }));
    
    res.json({
      success: true,
      collections: transformedCollections,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
});

// Get collection products
router.get('/products/collection/:handle', async (req, res) => {
  try {
    // First, find the collection by handle
    const collections = await shopifyService.getCollections();
    const collection = collections.find(c => c.handle === req.params.handle);
    
    if (!collection) {
      return res.status(404).json({
        success: false,
        message: 'Collection not found',
      });
    }
    
    const products = await shopifyService.getCollectionProducts(collection.id);
    const transformedProducts = products.map(transformProduct);
    
    res.json({
      success: true,
      products: transformedProducts,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
});

// Search products
router.get('/search', async (req, res) => {
  try {
    const query = req.query.q || '';
    const products = await shopifyService.searchProducts(query);
    
    const transformedProducts = products.map(transformProduct);
    
    res.json({
      success: true,
      results: transformedProducts,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
});

// Get shop info
router.get('/shop', async (req, res) => {
  try {
    const shop = await shopifyService.getShopInfo();
    
    res.json({
      success: true,
      name: shop.name,
      description: shop.description,
      primaryDomain: shop.domain,
      currencyCode: shop.currency,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
});

// Theme sections (homepage data)
router.get('/theme-sections', async (req, res) => {
  try {
    // Return static data for now
    // In production, this could fetch from Shopify metafields or a CMS
    res.json({
      success: true,
      heroSlides: [],
      genderCategories: [
        { title: 'Men', handle: 'mens', imageUrl: null },
        { title: 'Women', handle: 'womens', imageUrl: null },
        { title: 'Kids', handle: 'kids', imageUrl: null },
      ],
      featuredCollections: [],
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
});

module.exports = router;

