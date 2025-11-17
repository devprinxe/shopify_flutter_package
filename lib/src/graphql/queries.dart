/// All GraphQL queries organized by domain
class ShopifyQueries {
  // ==================== Customer Queries ====================
  
  static const String getCustomer = '''
    query getCustomer(\$customerAccessToken: String!) {
      customer(customerAccessToken: \$customerAccessToken) {
        id
        email
        firstName
        lastName
        phone
        acceptsMarketing
        createdAt
        updatedAt
        defaultAddress {
          id
          address1
          address2
          city
          province
          country
          zip
          phone
          firstName
          lastName
          company
        }
      }
    }
  ''';
  
  // ==================== Product Queries ====================
  
  static const String getProducts = '''
    query getProducts(\$first: Int!, \$after: String, \$query: String) {
      products(first: \$first, after: \$after, query: \$query) {
        pageInfo {
          hasNextPage
          hasPreviousPage
        }
        edges {
          cursor
          node {
            id
            title
            description
            handle
            productType
            vendor
            tags
            createdAt
            updatedAt
            availableForSale
            priceRange {
              minVariantPrice {
                amount
                currencyCode
              }
              maxVariantPrice {
                amount
                currencyCode
              }
            }
            images(first: 10) {
              edges {
                node {
                  id
                  url
                  altText
                  width
                  height
                }
              }
            }
            variants(first: 50) {
              edges {
                node {
                  id
                  title
                  price {
                    amount
                    currencyCode
                  }
                  availableForSale
                  quantityAvailable
                  selectedOptions {
                    name
                    value
                  }
                  image {
                    id
                    url
                    altText
                  }
                }
              }
            }
          }
        }
      }
    }
  ''';
  
  static const String getProductByHandle = '''
    query getProductByHandle(\$handle: String!) {
      productByHandle(handle: \$handle) {
        id
        title
        description
        descriptionHtml
        handle
        productType
        vendor
        tags
        createdAt
        updatedAt
        availableForSale
        priceRange {
          minVariantPrice {
            amount
            currencyCode
          }
          maxVariantPrice {
            amount
            currencyCode
          }
        }
        images(first: 20) {
          edges {
            node {
              id
              url
              altText
              width
              height
            }
          }
        }
        variants(first: 100) {
          edges {
            node {
              id
              title
              price {
                amount
                currencyCode
              }
              compareAtPrice {
                amount
                currencyCode
              }
              availableForSale
              quantityAvailable
              sku
              selectedOptions {
                name
                value
              }
              image {
                id
                url
                altText
              }
            }
          }
        }
      }
    }
  ''';
  
  // ==================== Collection Queries ====================
  
  static const String getCollections = '''
    query getCollections(\$first: Int!, \$after: String) {
      collections(first: \$first, after: \$after) {
        pageInfo {
          hasNextPage
          hasPreviousPage
        }
        edges {
          cursor
          node {
            id
            title
            description
            handle
            updatedAt
            image {
              id
              url
              altText
            }
          }
        }
      }
    }
  ''';
  
  static const String getCollectionByHandle = '''
    query getCollectionByHandle(\$handle: String!, \$first: Int!, \$after: String) {
      collectionByHandle(handle: \$handle) {
        id
        title
        description
        descriptionHtml
        handle
        updatedAt
        image {
          id
          url
          altText
        }
        products(first: \$first, after: \$after) {
          pageInfo {
            hasNextPage
            hasPreviousPage
          }
          edges {
            cursor
            node {
              id
              title
              description
              handle
              availableForSale
              priceRange {
                minVariantPrice {
                  amount
                  currencyCode
                }
              }
              images(first: 1) {
                edges {
                  node {
                    id
                    url
                    altText
                  }
                }
              }
            }
          }
        }
      }
    }
  ''';
  
  // ==================== Checkout Queries ====================
  
  static const String getCheckout = '''
    query getCheckout(\$checkoutId: ID!) {
      node(id: \$checkoutId) {
        ... on Checkout {
          id
          webUrl
          ready
          completedAt
          createdAt
          updatedAt
          email
          subtotalPrice {
            amount
            currencyCode
          }
          totalTax {
            amount
            currencyCode
          }
          totalPrice {
            amount
            currencyCode
          }
          lineItems(first: 250) {
            edges {
              node {
                id
                title
                quantity
                variant {
                  id
                  title
                  price {
                    amount
                    currencyCode
                  }
                  image {
                    url
                    altText
                  }
                  product {
                    id
                    title
                    handle
                  }
                }
              }
            }
          }
        }
      }
    }
  ''';
  
  // ==================== Order Queries ====================
  
  static const String getCustomerOrders = '''
    query getCustomerOrders(\$customerAccessToken: String!, \$first: Int!, \$after: String) {
      customer(customerAccessToken: \$customerAccessToken) {
        orders(first: \$first, after: \$after) {
          pageInfo {
            hasNextPage
            hasPreviousPage
          }
          edges {
            cursor
            node {
              id
              orderNumber
              processedAt
              financialStatus
              fulfillmentStatus
              totalPrice {
                amount
                currencyCode
              }
              subtotalPrice {
                amount
                currencyCode
              }
              totalShippingPrice {
                amount
                currencyCode
              }
              totalTax {
                amount
                currencyCode
              }
              lineItems(first: 250) {
                edges {
                  node {
                    title
                    quantity
                    variant {
                      id
                      title
                      price {
                        amount
                        currencyCode
                      }
                      image {
                        url
                        altText
                      }
                      product {
                        id
                        title
                        handle
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  ''';
}