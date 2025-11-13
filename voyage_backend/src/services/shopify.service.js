const axios = require('axios');
const shopifyConfig = require('../config/shopify.config');

class ShopifyService {
  constructor() {
    this.adminClient = axios.create({
      baseURL: shopifyConfig.getAdminApiUrl(),
      headers: {
        'X-Shopify-Access-Token': shopifyConfig.adminAccessToken,
        'Content-Type': 'application/json',
      },
    });
  }

  // Fetch Products
  async getProducts(limit = 50) {
    try {
      const response = await this.adminClient.get('/products.json', {
        params: { limit },
      });
      return response.data.products;
    } catch (error) {
      console.error('Error fetching products:', error.response?.data || error.message);
      throw new Error('Failed to fetch products from Shopify');
    }
  }

  // Fetch Single Product
  async getProductById(productId) {
    try {
      const response = await this.adminClient.get(`/products/${productId}.json`);
      return response.data.product;
    } catch (error) {
      console.error('Error fetching product:', error.response?.data || error.message);
      throw new Error('Product not found');
    }
  }

  // Fetch Collections
  async getCollections() {
    try {
      const response = await this.adminClient.get('/custom_collections.json');
      const customCollections = response.data.custom_collections;
      
      const smartResponse = await this.adminClient.get('/smart_collections.json');
      const smartCollections = smartResponse.data.smart_collections;
      
      return [...customCollections, ...smartCollections];
    } catch (error) {
      console.error('Error fetching collections:', error.response?.data || error.message);
      throw new Error('Failed to fetch collections');
    }
  }

  // Fetch Collection Products
  async getCollectionProducts(collectionId) {
    try {
      const response = await this.adminClient.get(`/collections/${collectionId}/products.json`);
      return response.data.products;
    } catch (error) {
      console.error('Error fetching collection products:', error.response?.data || error.message);
      throw new Error('Failed to fetch collection products');
    }
  }

  // Search Products
  async searchProducts(query) {
    try {
      const response = await this.adminClient.get('/products.json', {
        params: { 
          limit: 50,
          title: query,
        },
      });
      return response.data.products;
    } catch (error) {
      console.error('Error searching products:', error.response?.data || error.message);
      throw new Error('Search failed');
    }
  }

  // Fetch Lenses (products tagged as lenses)
  async getLenses() {
    try {
      // Fetch products with 'lens' tag
      const response = await this.adminClient.get('/products.json', {
        params: {
          product_type: 'Lens', // Or use tags if you prefer
          limit: 250,
        },
      });
      return response.data.products;
    } catch (error) {
      console.error('Error fetching lenses:', error.response?.data || error.message);
      return []; // Return empty array if no lenses found
    }
  }

  // Create Cart (using draft order)
  async createCart(lineItems) {
    try {
      const response = await this.adminClient.post('/draft_orders.json', {
        draft_order: {
          line_items: lineItems,
        },
      });
      return response.data.draft_order;
    } catch (error) {
      console.error('Error creating cart:', error.response?.data || error.message);
      throw new Error('Failed to create cart');
    }
  }

  // Get Shop Info
  async getShopInfo() {
    try {
      const response = await this.adminClient.get('/shop.json');
      return response.data.shop;
    } catch (error) {
      console.error('Error fetching shop info:', error.response?.data || error.message);
      throw new Error('Failed to fetch shop info');
    }
  }
}

module.exports = new ShopifyService();

