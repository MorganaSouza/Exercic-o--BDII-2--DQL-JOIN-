
    
    -- Exemplo do professor pra aprender
    
    create view Relatorio1 as
	select upper(emp.nome) "Empregado", emp.cpf as "CPF",
		date_format(emp.dataAdm, '%H:%i - %d/%m/%Y') "Data de Admissão", 
        concat('R$ ', format(emp.salario, 2, 'de_DE')) "Salário", 
		dep.nome "Departamento", tel.numero "Número de Telefone"
		from funcionario func
			inner join departamento dep on dep.idDepartamento = emp.Departamento_idDepartamento
			left join telefone tel on tel.empregado_cpf = emp.cpf
            where dataAdm between '2019-01-01' and '2022-03-31'
				order by dataAdm desc;
                
         -- Relatório 1       
create view Relatorio1 as
select upper(emp.nome) as "Empregado",
    emp.cpf as "CPF",
    date_format(emp.dataAdm, '%d/%m/%Y') as "Data de Admissão",
    concat('R$ ', format(emp.salario, 2, 'de_DE')) as "Salário",
    dep.nome as "Departamento",
    tel.numero as "Número de Telefone"
	from empregado emp
		inner join departamento dep on dep.idDepartamento = emp.Departamento_idDepartamento
		left join telefone tel on tel.empregado_cpf = emp.cpf
		where emp.dataAdm between '2019-01-01' and '2022-03-31'
			order by emp.dataAdm desc;
            
            select * from relatorio1;
            
		-- um ano a menos para aparecer a tabela --  

select upper(emp.nome) as "Empregado", emp.cpf "CPF" ,
	date_format(emp.dataAdm, '%d/%m/%Y') "Data de Admissão",
	concat('R$ ', format(emp.salario, 2, 'de_DE')) "Salário", 		
    dep.nome as "Departamento",
    tel.numero as "Número de Telefone"
		from empregado emp
			left join departamento dep on dep.idDepartamento = emp.Departamento_idDepartamento
			left join telefone tel on Empregado_cpf = emp.cpf
				where dataAdm between "2019-01-01" and "2023-03-31"
					order by dataAdm desc;		
            

          -- Relatório 2
create view Relatorio2 as
select upper(emp.nome) as "Empregado",
    emp.cpf as "CPF",
    date_format(emp.dataAdm, '%d/%m/%Y') as "Data de Admissão",
    concat('R$ ', format(emp.salario, 2, 'de_DE')) as "Salário",
    dep.nome as "Departamento",
    tel.numero as "Número de Telefone"
	from empregado emp
		inner join departamento dep on dep.idDepartamento = emp.Departamento_idDepartamento
		left join telefone tel on tel.empregado_cpf = emp.cpf
		where emp.salario < (select avg(salario) from petshop.Empregado)
			order by emp.nome;
            
            select * from relatorio2;
            
            -- apenas para ver a média            
select concat('R$ ', format(avg(salario), 2, 'de_DE')) "Média Salarial" from empregado;

-- Relatório 3
create view Relatorio3 as
select upper(dep.nome) as "Nome Departamento", count(emp.Departamento_idDepartamento) "Quantidade de Empregados",
	concat('R$ ', format(avg(emp.salario), 2, 'de_DE')) "Média salarial", 
	concat('R$ ', format(avg(emp.comissao), 2, 'de_DE')) "Média da Comissão"
	from departamento dep
		inner join empregado emp ON dep.idDepartamento = emp.Departamento_idDepartamento
        group by dep.nome
			order by dep.nome;
            
            select * from relatorio3;

-- Relatório 4
create view Relatorio4 as
select upper(emp.nome) "Nome", emp.cpf "CPF", emp.sexo "Gênero", count(ven.Empregado_cpf) "quantidade de vendas" ,
	concat('R$ ', format(sum(ven.valor), 2, 'de_DE')) "Total Valor Vendido", 
	concat('R$ ', format(sum(ven.comissao), 2, 'de_DE')) "Total Comissão das Vendas"
	from empregado emp
		join venda ven on emp.cpf = ven.Empregado_cpf and ven.comissao and ven.valor
        group by emp.cpf
			order by count(ven.Empregado_cpf) desc; 
    
select count(idVenda) from venda; -- só para contar mesmo --

select * from relatorio4;

-- Relatório 5
create view Relatorio5 as
select upper(emp.nome) as "Nome", emp.cpf "CPF" , emp.sexo "Gênero",
	concat('R$ ', format(emp.salario, 2, 'de_DE')) "Salário",
    count(its.quantidade)"Quantidade Vendas com Serviço",
    concat('R$ ', format(sum(its.valor), 2, 'de_DE'))"Total Valor Vendido com Serviço",
    coalesce(concat('R$ ', format(sum(ven.comissao), 2, 'de_DE')), "Sem comissão com serviços" ) "Total Comissão das Vendas com Serviço"
    from empregado emp
		inner join itensservico its on emp.cpf = its.Empregado_cpf
        left join venda ven on emp.cpf = ven.Empregado_cpf
        group by emp.cpf
			order by count(its.valor) desc;
            
            select * from relatorio5;

-- Relatório 6
create view Relatorio6 as
select pet.nome as "Nome do Pet", date_format(ven.data, '%d/%m/%Y') "Data do Serviço",
	  ser.nome "Nome do Serviço", its.quantidade "Quantidade",
	  concat('R$ ', format(its.valor, 2, 'de_DE')) "Valor",
	  emp.nome "Empregado que realizou o Serviço"
		from pet pet
			inner join itensservico its on pet.idPET = its.PET_idPET
			join venda ven on ven.idVenda = its.Venda_idVenda 
			join empregado emp on emp.cpf = its.Empregado_cpf 
			join servico ser on ser.idServico = its.Servico_idServico
				order by ven.data desc;
                
                select * from relatorio6;

-- Relatório 7
create view Relatorio7 as
select date_format(ven.data, '%d/%m/%Y') "Data da Venda", 
	  concat('R$ ', format(ven.valor, 2, 'de_DE')) "Valor",
	  concat('R$ ', format(ven.desconto, 2, 'de_DE')) "Desconto",
	  concat('R$ ', format((ven.valor - ven.desconto), 2, 'de_DE')) "Valor Final",
	  emp.nome "Empregado que realizou a venda"
		from venda ven
			join empregado emp on emp.cpf = ven.Empregado_cpf
			join cliente cli on cli.cpf = ven.Cliente_cpf
			where cli.cpf = "001.172.372-64"
				order by ven.data desc;
                
                select * from relatorio7;

-- Relatório 8
create view Relatorio8 as
select ser.nome "Nome do Serviço",
	 sum(its.quantidade) "Quantidade Vendas",
	 concat('R$ ', format(sum(its.valor), 2, 'de_DE')) "Total Valor Vendido"
	 from servico ser
		inner join itensservico its on Servico_idServico = ser.idServico
        group by ser.nome
			order by sum(its.quantidade) desc
			limit 10;
            
            select * from relatorio8;
            
-- Relatório 9
create view Relatorio9 as
select tipo "Tipo Forma Pagamento", 
    count(tipo)"Quantidade Vendas", concat('R$ ', format(sum(valorPago), 2, 'de_DE')) "Total Valor Vendido"
	from formapgvenda 
		group by tipo
			order by count(tipo) desc; 
            
            select * from relatorio9;

-- Relatório 10
create view Relatorio10 as
select date_format(ven.data, '%d/%m/%Y') as "Data Venda",
	(count(ivp.quantidade) + count(its.quantidade)) "Quantidade de Vendas",
	concat('R$ ', format((ven.valor), 2, 'de_DE')) "Valor Total Venda"
	from venda ven
		left join itensvendaprod ivp on ivp.Venda_idVenda = ven.idVenda
		left join itensservico its on its.Venda_idVenda = ven.idVenda
			group by (ven.idVenda)
				order by ven.data desc;
                
                select * from relatorio10;
                drop view relatorio10;
                
                
-- Relatório 11
create view Relatorio11 as
select pro.nome "Nome Produto", concat('R$ ', format(sum(pro.valorVenda), 2, 'de_DE')) "Valor Produto", pro.marca "Categoria do Produto",
coalesce(max(frn.nome), 'sem registro') "Nome Fornecedor", coalesce(max(frn.email), 'sem registro') "Email Fornecedor", coalesce(max(tel.numero), 'sem registro') "Telefone Fornecedor"
		from produtos pro
			left join itenscompra itc on itc.Produtos_idProduto = pro.idProduto
			left join compras com on com.idCompra = itc.Compras_idCompra
			left join fornecedor frn on frn.cpf_cnpj = com.Fornecedor_cpf_cnpj
			left join telefone tel on tel.Fornecedor_cpf_cnpj = frn.cpf_cnpj
				group by pro.idProduto
					order by pro.nome;
                    
                     select * from relatorio11;
                     
                     -- teste dos numeros
select f.nome "Nome", f.email "E-mail", t.numero "Telefone"
		from fornecedor f
        join telefone t on t.Fornecedor_cpf_cnpj = f.cpf_cnpj;
                     
-- Relatório 12
create view Relatorio12 as
select pro.nome "Nome Produto", 
		count(ivp.quantidade) "Quantidade (Total) Vendas",
		concat('R$ ', format(sum(ivp.valor), 2, 'de_DE'))  "Valor Total Recebido pela Venda do Produto)"
		from produtos pro
			join itensvendaprod ivp on ivp.Produto_idProduto = pro.idProduto
				group by pro.nome
					order by count(ivp.quantidade) desc;

					select * from relatorio12;
                    
-- -----------------------------------------------------
-- Aluna: Morgana Souza 
-- Turma: TADH036
-- -----------------------------------------------------

-- -----------------------------------------------------
                     