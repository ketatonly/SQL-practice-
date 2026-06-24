select * from member


INSERT INTO public.member(
	memname, istrainer, email, postalcode, birthday, gender, entrydate, parent)
VALUES 
('coach', TRUE, 'coach@xx.ge', 4565,'1988-12-01', 'm', NULL,  NULL),
('figaro',  FALSE, 'figaro@xx.ge',3674,'1989-05-07', 'm', NULL,  NULL),
('hope',  FALSE, 'hope@xx.ge',4565, '1965-09-14', 'f', '2016-03-01',  NULL),
('klopp',  TRUE,'klopp@xx.ge',4600, '1980-12-24', 'm', NULL,  NULL),
('lazy',  TRUE,'lazy@xx.ge', 4600, '1996-11-25', 'm', NULL,  NULL),
('lena',  TRUE, 'lena@xx.ge',0105, '1995-01-25', 'f', NULL,  NULL),
('lion',  FALSE, 'lion@xxx.ge',0103,  '1990-10-10', 'm', NULL, NULL),
('nelly',  TRUE,'luke@xx.ge',4565, '1990-04-21', 'f', NULL,  NULL),
('valerie', FALSE, 'val@xx.ge',0105,  '1970-03-20', 'f', NULL, NULL)
ON CONFLICT (memname) DO NOTHING;


INSERT INTO public.member(
	memname, istrainer, email, postalcode, birthday, gender, entrydate, parent)
VALUES 
('robin',  FALSE, 'nelly@xx.ge',4600, '2012-09-16', 'm', '2017-01-01',  'nelly'),
('rose',  FALSE, 'lion@xx.ge', 0107, '2015-02-10', 'f', NULL, 'lion'),
('val',  FALSE, 'val@xx.ge', 0103, '2013-07-12', 'm', '2020-05-01', 'figaro'),
('aron',  FALSE, 'klopp@xx.ge', 0103,'2013-11-06', 'm', '2020-01-01', 'klopp'),
('lisa',  FALSE, 'figaro@xx.ge', 4600,'2015-11-19', 'f', NULL, 'figaro'),
('luke',  FALSE, 'luke@xxx.ge', 4565,'1998-11-22', 'm', NULL,  'hope')
on conflict (memname) do nothing;

INSERT INTO public.trainer(
	memname, license, startdate)
	VALUES
('coach', TRUE, '2021-10-01'),
('klopp', TRUE, NULL),
('lazy', TRUE, NULL),
('lena', FALSE, NULL),
('nelly', FALSE, NULL)
on conflict (memname) do nothing;

INSERT INTO public.targetgroup(
	tcode, description)
	VALUES 
	('all', 'everybody'),
	('fam', 'families'),
	('kid', 'kinds up to 10'),
	('jun', 'young people 10 - 20'),
	('sen', 'seniors'),
	('men', 'courses for men'),
	('wom', 'courses for women')
	on conflict (tcode) do nothing;


INSERT INTO public.area(
	area, description, manager)
	VALUES 
('athletics', 'High jump, long jump, decathlon, penthalon, sprint distances and the like', 'nelly'),
('fitness', 'Comprises all courses that encrease healthy lifestyle and fitness', 'lena'),
('martialArt', 'Wrestling, Judo and the like', 'klopp'),
('watersport', 'All sports that have to do with water', 'lazy')
on conflict (area) do nothing;

select * from enrollment

INSERT INTO public.course(
	 course_name, targetgroup, area, trainer)
	VALUES 
('wrestling', 'men', 'martialArt', 'klopp'),
('waterball','men', 'watersport', 'klopp'),
('running', 'men', 'fitness', 'lazy'),
('jogging', 'fam', 'fitness', 'lena'),
('fitnessKids', 'kid', 'fitness', 'klopp'),
('high jump',  'fam', 'athletics', 'lena'),
('obstacle race', 'fam', 'athletics', 'lena'),
('swimming', 'fam', 'watersport', 'lena'),
('free style', 'kid', 'watersport', 'lazy'),
('aerobics', 'fam', 'fitness', 'lena');

INSERT INTO public.enrollment(
	memname, course_id)
	VALUES
('hope', 1),
('hope', 5),
('hope', 6),
('hope', 7),
('hope', 10),
('lion', 1),
('lion', 4),
('lion', 5),
('lion', 6),
('lion', 7),
('lion', 10),
('lisa', 6),
('lisa', 9),
('nelly', 1),
('nelly', 4),
('nelly', 5),
('nelly', 6),
('nelly', 7),
('nelly', 10),
('robin', 1),
('robin', 4),
('robin', 5),
('robin', 6),
('robin', 7),
('robin', 10),
('rose', 4),
('rose', 5),
('rose', 6),
('rose', 7),
('rose', 10),
('val', 1),
('val', 4),
('val', 5),
('val', 6),
('valerie', 1),
('valerie', 4),
('valerie', 5),
('valerie', 6),
('valerie', 7),
('valerie', 10);
