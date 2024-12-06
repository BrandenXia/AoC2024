use std::fs;

const PATTERN: [[char; 3]; 3] = [['M', ' ', 'S'], [' ', 'A', ' '], ['M', ' ', 'S']];

fn rotate_pattern(p: [[char; 3]; 3]) -> [[char; 3]; 3] {
    let mut new_pattern = [[' '; 3]; 3];
    for i in 0..3 {
        for j in 0..3 {
            new_pattern[j][2 - i] = p[i][j];
        }
    }
    new_pattern
}

fn count_matches(input: &Vec<Vec<char>>, p: [[char; 3]; 3]) -> usize {
    // match pattern with input, except the space, which can be anything
    let mut matches = 0;
    for i in 0..input.len() - 2 {
        for j in 0..input[0].len() - 2 {
            let mut matched = true;
            for k in 0..3 {
                for l in 0..3 {
                    if p[k][l] != ' ' && p[k][l] != input[i + k][j + l] {
                        matched = false;
                        break;
                    }
                }
                if !matched {
                    break;
                }
            }
            if matched {
                matches += 1;
            }
        }
    }
    matches
}

fn main() {
    let input: Vec<Vec<char>> = fs::read_to_string("input.txt")
        .unwrap()
        .lines()
        .map(|line| line.chars().collect())
        .collect();

    let mut patterns = Vec::new();
    let mut p = PATTERN;
    for _ in 0..4 {
        patterns.push(p);
        p = rotate_pattern(p);
    }

    let count: usize = patterns.iter().map(|p| count_matches(&input, *p)).sum();

    println!("{}", count);
}
