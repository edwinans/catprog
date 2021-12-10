# Backlog

## 10/12/2021

- essayer comprendre et exécuter [l'implem de Charity](https://github.com/mietek/charity-lang)

- [x] background: Algebraic Specification Methods

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