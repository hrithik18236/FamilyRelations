% FACTS

male('Tom').
male('Matt').
male('Stephen').
male('Mark').
male('Phineas').
male('Ferb').
male('Luke').

female('Mary').
female('Jane').
female('Julia').
female('Monica').
female('Candace').
female('Luna').

% parent(X, Y) is defined such that X is parent of Y
parent('Tom', 'Matt').
parent('Tom', 'Stephen').
parent('Tom', 'Jane').
parent('Mary', 'Matt').
parent('Mary', 'Stephen').
parent('Mary', 'Jane').
parent('Matt', 'Phineas').
parent('Matt', 'Ferb').
parent('Julia', 'Phineas').
parent('Julia', 'Ferb').
parent('Stephen', 'Luke').
parent('Stephen', 'Candace').
parent('Monica', 'Luke').
parent('Monica', 'Candace').
parent('Jane', 'Luna').
parent('Mark', 'Luna').

% child(X, Y) is defined such that X is child of Y
child('Matt', 'Tom').
child('Matt', 'Mary').
child('Stephen', 'Tom').
child('Stephen', 'Mary').
child('Jane', 'Tom').
child('Jane', 'Mary').
child('Phineas', 'Matt').
child('Phineas', 'Julia').
child('Ferb', 'Matt').
child('Ferb', 'Julia').
child('Luke', 'Stephen').
child('Luke', 'Monica').
child('Candace', 'Stephen').
child('Candace', 'Monica').
child('Luna', 'Jane').
child('Luna', 'Mark').


spouse('Tom', 'Mary').
spouse('Matt', 'Julia').
spouse('Stephen', 'Monica').
spouse('Mark', 'Jane').

% RULES

is_spouse(Groom, Bride) :- spouse(Groom, Bride) ; spouse(Bride, Groom).

husband(Husb, Wife) :- male(Husb), is_spouse(Husb, Wife).

wife(Wife, Husb) :- female(Wife), is_spouse(Husb, Wife).

father(Dad, Child) :- male(Dad), parent(Dad, Child).

mother(Mom, Child) :- female(Mom), parent(Mom, Child).

grandfather(Gran, Child) :- male(Gran), parent(Par, Child), parent(Gran, Par).

grandmother(Gran, Child) :- female(Gran), parent(Par, Child), parent(Gran, Par).

son(Child, Par) :- male(Child), child(Child, Par).

daughter(Child, Par) :- female(Child), child(Child, Par).

brother(Bro, Sib) :- 
	male(Bro), 
	father(Dad, Bro), father(Dad, Sib),
	Bro \= Sib, 
	mother(Mom, Bro), mother(Mom, Sib).

sister(Sis, Sib) :- 
	female(Sis), 
	father(Dad, Sib), father(Dad, Sis),
	Sis \= Sib, 
	mother(Mom, Sis), mother(Mom, Sib).

siblings(Sib1, Sib2) :- brother(Sib1, Sib2) ; sister(Sib1, Sib2).

aunt(Au, Nib) :- female(Au), parent(Par, Nib), sister(Au, Par).
aunt(Au, Nib) :- female(Au), parent(Par, Nib), brother(Bro, Par), is_spouse(Bro, Au).

uncle(Unc, Nib) :- male(Unc), parent(Par, Nib), brother(Unc, Par).
uncle(Unc, Nib) :- male(Unc), parent(Par, Nib), sister(Sis, Par), is_spouse(Unc, Sis).

brother_in_law(BIL, SIBL) :- is_spouse(SIBL, Spou), brother(BIL, Spou).
brother_in_law(BIL, SIBL) :-  sister(Sis, SIBL), is_spouse(BIL, Sis).

sister_in_law(SIL, SIBL) :- is_spouse(SIBL, Spou), sister(SIL, Spou).
sister_in_law(SIL, SIBL) :-  brother(Bro, SIBL), is_spouse(Bro, SIL).

father_in_law(FIL, CIL) :- male(FIL), is_spouse(Part, CIL), parent(FIL, Part).

mother_in_law(MIL, CIL) :- female(MIL), is_spouse(Part, CIL), parent(MIL, Part).

first_cousins(Cou, Child) :- parent(Par, Child), siblings(Par, X), parent(X, Cou).

second_cousins(Cou, Child) :- parent(Par, Child), first_cousins(X, Par), child(Cou, X).

cousins(Cou, Child) :- first_cousins(Cou, Child) ; second_cousins(Cou, Child).

relations(X, Spouse, Dad, Mom, Grandfather, Grandmother, Son, Daughter, Brother, Sister, Sibling, Aunt, Uncle, Brother_in_law, Sister_in_law, First_Cousin, Second_cousin) :- 
	is_spouse(X, Spouse); 
	father(Dad, X) ; mother(Mom, X); 
	grandfather(Grandfather, X) ; grandmother(Grandmother, X);
	son(Son, X); daughter(Daughter, X);
	brother(Brother, X) ; sister(Sister, X); siblings(Sibling, X);
	aunt(Aunt, X) ; uncle(Uncle, X); 
	brother_in_law(Brother_in_law, X); sister_in_law(Sister_in_law, X);
	first_cousins(First_Cousin, X); second_cousins(Second_cousin, X).