use sakila;
-- 1a
select first_name, last_name from actor;
-- 1b
select upper(concat(first_name, ' ', last_name)) as 'Actor Name' from actor;


-- 2a
select actor_id, first_name, last_name from actor
where first_name = 'Joe';
-- 2b
select first_name, last_name from actor
where last_name like '%GEN%';
-- 2c
select last_name, first_name from actor 
where last_name like '%LI%'
order by last_name, first_name;
-- 2d
select country_id, country from country
where country in ('Afghanistan','Bangladesh','China');


-- 3a
Alter table actor
add column description BLOB;
-- 3b
alter table actor
drop column description;


-- 4a
select last_name, count(last_name) as 'Actors with this last name' from actor
group by last_name
-- 4b
having count(last_name) > 1;
-- 4c
update actor
set first_name = 'HARPO' 
where first_name = 'GROUCHO' and last_name = 'WILLIAMS';
-- 4d
update actor
set first_name = 'GROUCHO' where first_name = 'HARPO';


-- 5a
CREATE TABLE if not exists address (
  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(50) NOT NULL,
  `address2` varchar(50) DEFAULT NULL,
  `district` varchar(20) NOT NULL,
  `city_id` smallint(5) unsigned NOT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `location` geometry NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`),
  KEY `idx_fk_city_id` (`city_id`),
  SPATIAL KEY `idx_location` (`location`),
  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8


-- 6a
select s.first_name as 'First Name', s.last_name as 'Last Name', a.address as 'Address' from staff s 
inner join address a on a.address_id = s.address_id;
-- 6b
select fname 'First Name', lname 'Last Name',concat('$',format(sum(amount),2)) "Tot paid Aug '05" from (
	select s.first_name fname, s.last_name lname, p.staff_id staffid, p.amount amount, p.payment_date pdate from staff s
	inner join payment p on p.staff_id = s.staff_id
	having payment_date between '2005-08-01 00:00:00' and '2005-09-01 00:00:00'
) A
group by A.staffid;
-- 6c
select f.title, count(a.actor_id) from film f
inner join film_actor a on a.film_id = f.film_id
group by f.title;
-- 6d
select f.title Title, count(i.inventory_id) 'Num copies' from inventory i
inner join film f on f.film_id = i.film_id
group by f.film_id
having f.title like 'HUNCHBACK IMPOSSIBLE';
-- 6e
select c.first_name 'First Name', c.last_name 'Last Name', concat('$',format(sum(p.amount), 2)) 'Total Amount Paid' from payment p
inner join customer c on c.customer_id = p.customer_id
group by c.customer_id
order by c.last_name;


-- 7a
select title from film where language_id in (
select language_id from language where name = 'English')
and (title like 'K%' or title like 'Q%');
-- 7b
select first_name, last_name from actor where actor_id in (
select actor_id from film_actor where film_id in ( 
select film_id from film where title = 'Alone Trip'));
-- 7c
select cust.first_name FirstName, cust.last_name LastName, cust.email Email, c.country Country from customer cust
inner join address a on a.address_id = cust.address_id
inner join city on a.city_id = city.city_id
inner join country c on city.country_id = c.country_id 
having Country = 'Canada';
-- 7d
select f.title, c.name from category c
inner join film_category fc on fc.category_id = c.category_id
inner join film f on f.film_id = fc.film_id
having c.name like 'family';
-- 7e
select f.title, count(r.rental_date) 'Count of rentals' from rental r
inner join inventory i on i.inventory_id = r.inventory_id
inner join film f on f.film_id = i.film_id
group by f.film_id
order by count(r.rental_date) DESC;
-- 7f
select s.store_id 'Store ID',concat('$',format(sum(p.amount),2)) 'Total Revenue' from payment p
inner join rental r on p.rental_id = r.rental_id
inner join inventory i on r.inventory_id = i.inventory_id
inner join store s on i.store_id = s.store_id
group by s.store_id;
-- 7g
select s.store_id StoreID, c.city City, co.country Country from store s
inner join address a on s.address_id = a.address_id
inner join city c on c.city_id = a.city_id
inner join country co on co.country_id = c.country_id;
-- 7h
select cat.name Genre, concat('$',format(sum(p.amount),2)) SumRevenue from category cat
inner join film_category fc on fc.category_id = cat.category_id
inner join inventory i on fc.film_id = i.film_id
inner join rental r on r.inventory_id = i.inventory_id
inner join payment p on p.rental_id = r.rental_id
group by Genre
order by SumRevenue DESC
limit 5;


-- 8a
create view topFiveRev as 
select cat.name Genre, concat('$',format(sum(p.amount),2)) SumRevenue from category cat
inner join film_category fc on fc.category_id = cat.category_id
inner join inventory i on fc.film_id = i.film_id
inner join rental r on r.inventory_id = i.inventory_id
inner join payment p on p.rental_id = r.rental_id
group by Genre
order by SumRevenue DESC
limit 5;
-- 8b
select * from topFiveRev;
-- 8c
drop view topFiveRev;