# Análise de Dados de E-Commerce com SQL
A análise de dados se tornou essencial na maioria das empresas hoje em dia. Os insights derivados da análise de dados podem resultar em melhorias significativas em várias indústrias e áreas de negócios. 

Neste artigo, irei realizar uma análise em um conjunto de dados de bem conhecido de E-Commerce do Brasil, o que nos permitirá compreender melhor o comportamento do consumidor, avaliar o desempenho de produtos e funcionários, entre outras informações, utilizando a linguagem SQL.

SQL, ou Linguagem de Consulta Estruturada, é uma linguagem de programação destinada a gerenciar e manipular sistemas de banco de dados relacionais.É vastamente empregada para consultas, inserções, atualizações e exclusões de dados em um banco de dados. A SQL é vital para a análise de dados, pois habilita os usuários a realizar consultas complexas e extrair insights de grandes conjuntos de dados de maneira eficaz.

# Fonte dos Dados

Vamos realizar a análise através de um conjunto de dados muito famoso na plataforma do Kaggle, o "Brazilian E-Commerce Public Dataset by Olist". 

O conjunto de dados contém informações de 100 mil pedidos de 2016 a 2018, feitos em vários marketplaces no Brasil. Seus recursos permitem visualizar um pedido em múltiplas dimensões: desde status do pedido, preço, desempenho de pagamento e frete até a localização do cliente, atributos do produto e, finalmente, avaliações escritas pelos clientes. 

O conjunto de dados é constituído por 9 tabelas diferentes, cada uma com particularidades específicas, e segue o diagrama de relacionamento abaixo:

![1_aXTlOcs3-l0L4Bi_pyiADA](https://github.com/Felintox/Sql_Olist_Analise/assets/129033082/8d16ad80-0849-4786-92d6-b7932b2ed3a1)

## Tabelas do nosso Conjunto de Dados:

olist_customers_dataset.csv : Tabela com informação dos Clientes

olist_geolocation_dataset.csv: Tabela com informações de Localização dos clientes.

olist_order_items_dataset.csv: Tabela com os pedidos feitos.

olist_order_payments_dataset.csv: Tabela com informação dos pagamentos.

olist_order_reviews_dataset.csv: Tabela com as avaliações.

olist_orders_dataset.csv: Informações mais detalhadas sobre os pedidos.

olist_orders_sellers_dataset.csv: Tabela com informações do vendedor.

olist_products_dataset.csv: Tabela com informações dos produtos e suas categorias.

# Importação dos Dados

Como já foi dito, utilizaremos o SQL para realizar nossa Análise. Os arquivos estão no formato CSV (Comma-separated values).

Como este conjunto de dados tem muitas linhas, para realizar a importação para o SGBD MySQL, será necessário fazer um script de SQL. Como são nove tabelas, irei apenas mostrar como importar uma delas, porém o código completo está no meu GitHub.

![Sem título](https://github.com/Felintox/Sql_Olist_Analise/assets/129033082/ea6caf99-c3ce-45fa-ad0e-61781a85f124)

Na imagem o código está  criando uma tabela (CREATE TABLE) e depois importando (LOAD DATA INFILE | INTO TABLE ) os valores dentro desta tabela.

Agora, começaremos a fazer as análises deste conjunto de dados. É importante prestar atenção no esquema de relacionamento do conjunto para realizar as análises de maneira correta.

# Análise 


## 1. Quais são as categorias de produtos mais vendidas?

Para resolver esse problema, faremos uma consulta com JOIN entre a tabela de produtos (olist_products_dataset) e a tabela de itens de pedidos (olist_order_items_dataset), depois um GROUP BY por product_category_name e ordenando pela quantidade de vendas, calculada pela função de agregação COUNT()

![medium_sql1](https://github.com/Felintox/Sql_Olist_Analise/assets/129033082/ce036705-7d05-4c54-aeac-c5d753a91f6d)

Temos que produtos categorizados como "cama_mesa_banho", "beleza_saude" e "esporte_lazer" lideram nosso top 3 produtos mais vendidos.

## 2. Quais são os vendedores que mais fizeram vendas ? 

Agruparemos o seller_id (identificador único para cada vendedor) e aplicaremos uma função de agregação COUNT() que faz a contagem da quantidade de vendas realizadas por aquele vendedor em específico.

![medium_sql2](https://github.com/Felintox/Sql_Olist_Analise/assets/129033082/6b5e6c5f-0fb9-4308-b195-1847e7d3a174)

## 3. Das vendas concluídas, quantas foram entregues no prazo e quantas fora do prazo (ou atrasadas)?

Filtraremos esta tabela apenas pelos pedidos entregues. Nessa consulta, usei o conceito de subqueries em SQL, que é, basicamente, uma consulta embutida dentro de outra consulta.

![medium_sql3](https://github.com/Felintox/Sql_Olist_Analise/assets/129033082/cbef2097-c026-4032-b904-8213ad43283b)
![1_mLNSS7yo8e6IBqy5a8QLCg](https://github.com/Felintox/Sql_Olist_Analise/assets/129033082/5ceda30e-7455-4aea-92a1-a3300a8b3793)

Aproximadamente 93% das entregas foram no prazo e cerca de 7% chegaram atrasadas.

## 4. Os produtos com as melhores e piores avaliações

Precisamos fazer duas utilizações do JOIN para unir as três tabelas necessárias para realizar esta análise.

![medium_sql4](https://github.com/Felintox/Sql_Olist_Analise/assets/129033082/865afbca-2c02-49da-8634-462bbc774775)

Estes são os produtos mais bem avaliados. Claro que, provavelmente, produtos com maior quantidade de avaliações podem ter uma credibilidade maior que um produto com apenas 15 avaliações.

Aplicando uma ordenação diferente teremos os com avaliações mais baixas.

![medium_sql5](https://github.com/Felintox/Sql_Olist_Analise/assets/129033082/9b4e2455-fed4-48b1-916a-65108e11d036)

Alguns produtos têm valores de categoria vazios, e isso se deve à falta de informação da categoria do produto.

## 5. Quais produtos têm a maior quantidade de pedidos cancelados?

![1_mLNSS7yo8e6IBqy5a8QLCg](https://github.com/Felintox/Sql_Olist_Analise/assets/129033082/9f020bb7-a5e6-42cc-bc8b-c6fa945a9071)

![medium_sql6](https://github.com/Felintox/Sql_Olist_Analise/assets/129033082/d305bbdb-1a21-4d62-b526-8ae5daa34dc9)


Temos que a categoria esporte_lazer tem o maior número de pedidos cancelados, seguida de utilidades_domesticas.

# Conclusão

A análise de dados é fundamental nos dias atuais, considerando a enorme quantidade de informações disponíveis. Fazer uso desses dados de uma maneira correta pode trazer grandes vantagens para uma empresa, com insights que, devido à grande quantidade de informações produzidas, dificilmente seriam percebidos de outra forma. 

O SQL é uma ferramenta muito poderosa para a análise de dados. Como analista de dados, é uma ferramenta utilizada no dia a dia da função.

# Fonte de Dados: 

[Brazilian E-Commerce Public Dataset by Olist (kaggle.com)](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
## Redes Sociais :

Linkedln : [Gabriel Felinto | LinkedIn](https://www.linkedin.com/in/gabrielfelinto/)

Github: [Felintox (Gabriel Felinto) (github.com)](https://github.com/Felintox)



