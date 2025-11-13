const express = require('express');
const router = express.Router();
const shopifyService = require('../services/shopify.service');
const { transformLens, categorizeLens } = require('../utils/lens-categorizer');

// Get lens options (categorized)
router.get('/lens-options', async (req, res) => {
  try {
    const lensProducts = await shopifyService.getLenses();
    
    const antiGlareLenses = [];
    const blueBlockLenses = [];
    const colourLenses = [];
    const allLenses = [];

    lensProducts.forEach(product => {
      const transformedLens = transformLens(product);
      allLenses.push(transformedLens);

      const category = categorizeLens(product);
      
      if (category === 'antiglare') {
        antiGlareLenses.push(transformedLens);
      } else if (category === 'blueblock') {
        blueBlockLenses.push(transformedLens);
      } else if (category === 'colour') {
        colourLenses.push(transformedLens);
      }
    });

    res.json({
      success: true,
      antiGlareLenses,
      blueBlockLenses,
      colourLenses,
      allLenses,
    });
  } catch (error) {
    console.error('Error fetching lens options:', error);
    res.status(500).json({
      success: false,
      message: error.message,
      antiGlareLenses: [],
      blueBlockLenses: [],
      colourLenses: [],
      allLenses: [],
    });
  }
});

module.exports = router;

