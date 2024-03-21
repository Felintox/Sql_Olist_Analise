select seller_id,count(product_id) as qnt_vendas
from olist_order_items
group by seller_id
order by qnt_vendas DESC