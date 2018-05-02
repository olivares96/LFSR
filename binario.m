n=4; %lenthg of the cypher

for i=1:2^n -1
    numero = i
    numero_binario =dec2bin(i,n)
    
    vector_numero_binario=num2str(numero_binario)-'0'
    
    codigo_cod=c(i,:)
    numero_codificado =xor (vector_numero_binario,c(i,:))
    numero_salida = xor (numero_codificado,c(i,:))
    
    matriz_mensaje(i,:)=(vector_numero_binario)
    matriz_codificada(i,:)=(numero_codificado)
    matriz_salida(i,:)=(numero_salida)
end