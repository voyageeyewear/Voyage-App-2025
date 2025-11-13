/**
 * Categorize lenses based on title and tags
 */
function categorizeLens(product) {
  const title = (product.title || '').toLowerCase();
  const tags = (product.tags || '').toLowerCase();
  const description = (product.body_html || '').toLowerCase();
  
  const searchText = `${title} ${tags} ${description}`;

  // Anti-glare detection
  if (
    searchText.includes('anti-glare') ||
    searchText.includes('antiglare') ||
    searchText.includes('anti glare') ||
    searchText.includes('ar coating')
  ) {
    return 'antiglare';
  }

  // Blue block detection
  if (
    (searchText.includes('blue') && searchText.includes('block')) ||
    searchText.includes('blueblock') ||
    searchText.includes('blue cut') ||
    searchText.includes('blue light') ||
    searchText.includes('blu ray')
  ) {
    return 'blueblock';
  }

  // Colour lens detection
  if (
    searchText.includes('color') ||
    searchText.includes('colour') ||
    searchText.includes('tint') ||
    searchText.includes('mirror') ||
    searchText.includes('gradient') ||
    searchText.includes('polarized')
  ) {
    return 'colour';
  }

  return 'general';
}

/**
 * Transform lens product to simplified format
 */
function transformLens(product) {
  const variant = product.variants && product.variants[0];
  const category = categorizeLens(product);

  return {
    id: product.id.toString(),
    title: product.title,
    price: variant ? parseFloat(variant.price) : 0,
    description: product.body_html || '',
    features: extractFeatures(product.body_html || ''),
    category,
    variantId: variant ? variant.id.toString() : product.id.toString(),
    imageUrl: product.image ? product.image.src : null,
  };
}

/**
 * Extract features from HTML description
 */
function extractFeatures(html) {
  const features = [];
  
  // Remove HTML tags
  const text = html.replace(/<[^>]*>/g, '');
  
  // Split by common delimiters
  const lines = text.split(/[•\n\-]/);
  
  lines.forEach(line => {
    const trimmed = line.trim();
    if (trimmed && trimmed.length > 5 && trimmed.length < 100) {
      features.push(trimmed);
    }
  });

  return features.slice(0, 5); // Return max 5 features
}

module.exports = {
  categorizeLens,
  transformLens,
  extractFeatures,
};

