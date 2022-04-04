class Property < ApplicationRecord
  enum currency: { clp: 'clp', uf: 'uf' }
end
