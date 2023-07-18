clear all;
arr = [1:1:1e3, 1].';
b_arr = [ones(2e4, 1); arr; zeros(1, 1)];
x = finddelay(arr, b_arr);