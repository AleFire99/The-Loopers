function tfsum = sumtf(tf1,tf2)
tf2.Denominator
tf1d = tf(tf1.Denominator{:},1);
tf1n = tf(tf1.Numerator{:},1);

tf2d = tf(tf2.Denominator{:},1);
tf2n = tf(tf2.Numerator{:},1);

tfsum = (tf1n*tf2d + tf2n*tf1d)/(tf1d)/tf2d
end

