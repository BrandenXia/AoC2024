use std::fs;

fn transpose<T: Copy>(matrix: &Vec<Vec<T>>) -> Vec<Vec<T>> {
    (0..matrix[0].len())
        .map(|i| matrix.iter().map(|row| row[i]).collect())
        .collect()
}

fn diagonal<T: Copy>(matrix: &Vec<Vec<T>>) -> Vec<Vec<T>> {
    let mut diagonals = vec![];
    for k in 0..matrix.len() + matrix[0].len() - 1 {
        let mut diagonal = vec![];
        for i in 0..matrix.len() {
            let j = k as isize - i as isize;
            if j >= 0 && j < matrix[0].len() as isize {
                diagonal.push(matrix[i][j as usize]);
            }
        }
        if !diagonal.is_empty() {
            diagonals.push(diagonal);
        }
    }
    for k in 0..matrix.len() + matrix[0].len() - 1 {
        let mut diagonal = vec![];
        for i in 0..matrix.len() {
            let j = k as isize - (matrix.len() - 1 - i) as isize;
            if j >= 0 && j < matrix[0].len() as isize {
                diagonal.push(matrix[i][j as usize]);
            }
        }
        if !diagonal.is_empty() {
            diagonals.push(diagonal);
        }
    }

    diagonals
}

fn to_strs(matrix: &Vec<Vec<char>>) -> Vec<String> {
    matrix.iter().map(|row| row.iter().collect()).collect()
}

fn count_occurrences(s: &str, sub: &str) -> usize {
    s.match_indices(sub).count()
}

fn all_occurrences(s: &str) -> usize {
    count_occurrences(s, SUBSTR) + count_occurrences(s, SUBSTR_REV)
}

fn vec_occurs(vec: &Vec<String>) -> usize {
    vec.iter().map(|s| all_occurrences(s)).sum()
}

const SUBSTR: &str = "XMAS";
const SUBSTR_REV: &str = "SAMX";

fn main() {
    let input = fs::read_to_string("input.txt").unwrap();
    let horizontal = input
        .lines()
        .map(|line| line.chars().collect())
        .collect::<Vec<Vec<char>>>();
    let hori_strs: Vec<_> = to_strs(&horizontal);
    let vertical = transpose(&horizontal);
    let vert_strs: Vec<_> = to_strs(&vertical);
    let diag = diagonal(&horizontal);
    let diag_strs: Vec<_> = to_strs(&diag);

    let occurrences = vec_occurs(&hori_strs) + vec_occurs(&vert_strs) + vec_occurs(&diag_strs);

    println!("{}", occurrences);
}
