# Backlog

## 10/12/2021

- essayer de comprendre et exécuter [l'implem de Charity](https://github.com/mietek/charity-lang)

Lecture -> *Hugino: A Categorical Programming Language*
- [x] background: Algebraic Specification Methods
- [x] category theory
- [x] CDT
- [ ] pas compris: the product functor is the right adjoint of the diagonal functor.(page 9-10)
### **Concepts**

#### ***1. Category***
- collection d'objet C
- collection de morphisme (Arrow) Hom(A,B)
- composition associative: f . g
- identité pour chaque objet: I:A→A
- des isomorphismes
- opposite category: Hom_op(A,B) = Hom(B,A)

#### ***2. Produit d'Objets***
soit X1 et X2 dans C,  
X = X1 x X2  
muni de p1 = X → X1 et p2 = X → X2
tq. pour tout Y et f1: Y → X1 et f2: Y -> X2  
unique morphisme: f: Y → X1 x X2

#### ***3. Somme d'Objets***
soit X1 et X2 dans C,  
X = X1 + X2  
i1: X1 → X et i2: X2 → X  
f1: X1 → Y et f2 = X2 → Y
unique morphisme: f: X1 + X2 → Y

#### ***4. Produit de Category***
C x D
- Objets: <A,B>, A in C et B in D
- Morphismes:  <A1, B1> → <A2, B2> = (f, g),  
   f : A1 → A2 et g : B1 → B2
- Composition: <f2, g2> . <f1, g1> = <f2 . f1, g2 . g1>
- identité: I = <I_A, I_B>

#### ***5. Functor***
Functor F : C → D  
- X in C => F(X) in D
- f: X → Y, F(f): F(X) → F(Y) et F(g . f) = F(g) . F(f)
- Contravariance; F(f): F(Y) → F(X)

#### ***6. Exponential***
pour les ensemble:  
B^A: ensemble des fonctions de A dans B   
f : A -> B,  
eval (f,x) = f(x)

### Category <-> Langages de Programmation
Liens:

1) Example de typage de somme
A + B est défini avec 
i1: A → A + B et i2: B → A + B
et donc le type de (A+B) peut être obtenu a partir du type de i1 et i2.
comme pour l'addition

2) left adj nat with pr(,)
zero: 1 → nat  
succ: nat → nat   
`add = eval . <pr(curry(p2), curry(succ . eval)) . p1, p2>`  