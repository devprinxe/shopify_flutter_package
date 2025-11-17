/// All GraphQL mutations organized by domain
class ShopifyMutations {
  // ==================== Auth Mutations ====================
  
  static const String customerCreate = '''
    mutation customerCreate(\$input: CustomerCreateInput!) {
      customerCreate(input: \$input) {
        customer {
          id
          email
          firstName
          lastName
        }
        customerUserErrors {
          code
          field
          message
        }
      }
    }
  ''';
  
  static const String customerAccessTokenCreate = '''
    mutation customerAccessTokenCreate(\$input: CustomerAccessTokenCreateInput!) {
      customerAccessTokenCreate(input: \$input) {
        customerAccessToken {
          accessToken
          expiresAt
        }
        customerUserErrors {
          code
          field
          message
        }
      }
    }
  ''';
  
  static const String customerAccessTokenDelete = '''
    mutation customerAccessTokenDelete(\$customerAccessToken: String!) {
      customerAccessTokenDelete(customerAccessToken: \$customerAccessToken) {
        deletedAccessToken
        deletedCustomerAccessTokenId
        userErrors {
          field
          message
        }
      }
    }
  ''';
  
  static const String customerRecover = '''
    mutation customerRecover(\$email: String!) {
      customerRecover(email: \$email) {
        customerUserErrors {
          code
          field
          message
        }
      }
    }
  ''';
  
  static const String customerReset = '''
    mutation customerReset(\$id: ID!, \$input: CustomerResetInput!) {
      customerReset(id: \$id, input: \$input) {
        customer {
          id
        }
        customerAccessToken {
          accessToken
          expiresAt
        }
        customerUserErrors {
          code
          field
          message
        }
      }
    }
  ''';
  
  // ==================== Customer Update Mutations ====================
  
  static const String customerUpdate = '''
    mutation customerUpdate(\$customerAccessToken: String!, \$customer: CustomerUpdateInput!) {
      customerUpdate(customerAccessToken: \$customerAccessToken, customer: \$customer) {
        customer {
          id
          email
          firstName
          lastName
          phone
          acceptsMarketing
        }
        customerAccessToken {
          accessToken
          expiresAt
        }
        customerUserErrors {
          code
          field
          message
        }
      }
    }
  ''';
  
  // ==================== Checkout Mutations ====================
  
  static const String checkoutCreate = '''
    mutation checkoutCreate(\$input: CheckoutCreateInput!) {
      checkoutCreate(input: \$input) {
        checkout {
          id
          webUrl
          ready
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
                }
              }
            }
          }
        }
        checkoutUserErrors {
          code
          field
          message
        }
      }
    }
  ''';
  
  static const String checkoutLineItemsAdd = '''
    mutation checkoutLineItemsAdd(\$checkoutId: ID!, \$lineItems: [CheckoutLineItemInput!]!) {
      checkoutLineItemsAdd(checkoutId: \$checkoutId, lineItems: \$lineItems) {
        checkout {
          id
          webUrl
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
                }
              }
            }
          }
          subtotalPrice {
            amount
            currencyCode
          }
          totalPrice {
            amount
            currencyCode
          }
        }
        checkoutUserErrors {
          code
          field
          message
        }
      }
    }
  ''';
  
  static const String checkoutLineItemsUpdate = '''
    mutation checkoutLineItemsUpdate(\$checkoutId: ID!, \$lineItems: [CheckoutLineItemUpdateInput!]!) {
      checkoutLineItemsUpdate(checkoutId: \$checkoutId, lineItems: \$lineItems) {
        checkout {
          id
          webUrl
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
                }
              }
            }
          }
          subtotalPrice {
            amount
            currencyCode
          }
          totalPrice {
            amount
            currencyCode
          }
        }
        checkoutUserErrors {
          code
          field
          message
        }
      }
    }
  ''';
  
  static const String checkoutLineItemsRemove = '''
    mutation checkoutLineItemsRemove(\$checkoutId: ID!, \$lineItemIds: [ID!]!) {
      checkoutLineItemsRemove(checkoutId: \$checkoutId, lineItemIds: \$lineItemIds) {
        checkout {
          id
          webUrl
          lineItems(first: 250) {
            edges {
              node {
                id
                title
                quantity
              }
            }
          }
          subtotalPrice {
            amount
            currencyCode
          }
          totalPrice {
            amount
            currencyCode
          }
        }
        checkoutUserErrors {
          code
          field
          message
        }
      }
    }
  ''';
  
  static const String checkoutEmailUpdate = '''
    mutation checkoutEmailUpdate(\$checkoutId: ID!, \$email: String!) {
      checkoutEmailUpdateV2(checkoutId: \$checkoutId, email: \$email) {
        checkout {
          id
          email
        }
        checkoutUserErrors {
          code
          field
          message
        }
      }
    }
  ''';
}